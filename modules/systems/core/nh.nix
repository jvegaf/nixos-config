{
  self,
  ...
}:
{

  flake.nixosModules.nh = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nh
    ];
  };

  flake.wrappers.nh =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.nh ];

      flake = "$HOME/nixos-config";
    };
}
