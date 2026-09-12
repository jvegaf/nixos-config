{ self, inputs, ... }: {
  flake.nixosModules.vm-configuration =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.vm-hardware
        self.nixosModules.desktop
        self.nixosModules.home
      ];

      networking.hostName = "vm";
      system.stateVersion = "25.05";

      nixpkgs.config = {
        allowBroken = true;
        allowUnfree = true;
      };

      virtualisation.vmVariant = {
        virtualisation = {
          # memorySize = 4096;
          memorySize = 8192;
          diskSize = 20480;
          # cores = 4;
          cores = 8;
          graphics = true;
          qemu.options = [
            "-device virtio-vga"
            "-display gtk"
          ];
        };

        # Disable ly for VM, use auto-login instead
        services.displayManager.ly.enable = lib.mkForce false;
        services.getty.autologinUser = "th3g3ntl3man";
      };

      home-manager.users.th3g3ntl3man = {
        custom.orcaslicer.enable = true;
      };
    };
}
