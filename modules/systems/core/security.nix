{
  flake.nixosModules.security = { pkgs, ... }: {
    security.polkit.enable = true;
    security.rtkit.enable = true;
  };
}
