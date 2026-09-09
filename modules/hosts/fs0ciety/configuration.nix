# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.fs0ciety-configuration =
    { config, pkgs, ... }:

    {
      imports = [
        # Include the results of the hardware scan.
        # (import ../disks/gpt-ext4.nix { device = "/dev/nvme0n1"; })
        (inputs.hardware + "/common/cpu/intel")
        (inputs.hardware + "/common/gpu/intel/kaby-lake")
        self.diskoConfigurations.hostFs0ciety
        self.nixosModules.fs0ciety-hardware
        self.nixosModules.desktop
        self.nixosModules.home
      ];

      # nix.settings.experimental-features = ["nix-command" "flakes"];
      #
      # # Bootloader.
      # boot.loader.systemd-boot.enable = true;
      # boot.loader.efi.canTouchEfiVariables = true;
      #
      # # Use latest kernel.
      boot.kernelPackages = pkgs.linuxPackages_latest;

      hardware = {
        cpu.intel.enableRedistributableFirmware = true;
        enableRedistributableFirmware = true;
        nvidia = {
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          powerManagement.enable = true;
          modesetting.enable = true;
          nvidiaSettings = true;
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
      networking.hostName = "fs0ciety"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      services.xserver.enable = true;
      services.xserver.videoDrivers = [
        # "modesetting"
        "nvidia"
      ];

      # hardware.nvidia = {
      #   package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      #   modesetting.enable = true;
      #
      #   # Gestión de energía de NVIDIA
      #   powerManagement.enable = true;
      #
      #   # La MX150 es Pascal, por lo que requiere los drivers cerrados (open = false)
      #   open = false;
      #
      #   # Habilita el menú de configuración de NVIDIA (nvidia-settings)
      #   nvidiaSettings = true;
      #
      #   # Configuración de gráficos híbridos (PRIME) en modo Offload
      #   prime = {
      #     offload = {
      #       enable = true;
      #       enableOffloadCmd = true;
      #     };
      #     intelBusId = "PCI:0:2:0";
      #     nvidiaBusId = "PCI:1:0:0";
      #   };
      # };

      environment.systemPackages = with pkgs; [
        nvtopPackages.full # Monitor de GPU

        mesa-demos # Info OpenGL (glxinfo)
        # Utilidades sistema
        lm_sensors # Sensores de temperatura
      ];

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;

      home-manager.users.th3g3ntl3man = {
        custom.orcaslicer.enable = true;
      };
      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "26.05"; # Did you read the comment?

    };
}
