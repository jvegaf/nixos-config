{ self, inputs, ... }: {
  flake.nixosModules.networking = { pkgs, ... }: {
    networking.networkmanager.enable = true;
    hardware.firmware = [ pkgs.linux-firmware ];
    hardware.enableRedistributableFirmware = true;

    services.resolved.enable = true;

    # environment.systemPackages = [ pkgs.protonvpn-gui ];
  };
}
