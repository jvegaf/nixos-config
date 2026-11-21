{ self, inputs, ... }: {
  flake.nixosModules.services = { pkgs, lib, ... }: {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = lib.mkDefault true;
  };
}
