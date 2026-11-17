{ self, ... }: {
  flake.homeModules.creality-print = { pkgs, ... }: {
    home.packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.creality-print
    ];
  };
}
