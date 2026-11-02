{ self, inputs, ... }:
{
  flake.nixosModules.fs0ciety-configuration =
    { config, pkgs, ... }:
    {
      imports = [
        (inputs.hardware + "/common/cpu/intel")
        (inputs.hardware + "/common/gpu/intel/kaby-lake")
        self.nixosModules.fs0ciety-hardware
        self.nixosModules.desktop
        self.nixosModules.home
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      hardware = {
        enableRedistributableFirmware = true;
        nvidia = {
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          powerManagement.enable = true;
          modesetting.enable = true;
          nvidiaSettings = true;
          prime = {
            offload.enable = true;
            offload.enableOffloadCmd = true;
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };

      networking.hostName = "fs0ciety";
      services.xserver.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      services.libinput.enable = true;

      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PasswordAuthentication = true;
          # KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "th3g3ntl3man" ];
          MaxAuthTries = 3;
          # PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
        };
      };

      environment.systemPackages = with pkgs; [
        nvtopPackages.full
        mesa-demos
        lm_sensors
      ];

      home-manager.users.th3g3ntl3man = {
        custom.orcaslicer.enable = true;
      };

      system.stateVersion = "26.05";
    };
}
