{ self, ... }: {
  flake.homeModules.flatcam = { pkgs, ... }: {
    home.packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.flatcam
    ];
  };
}
