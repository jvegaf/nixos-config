{ self, lib, ... }: {
  flake.homeModules.flatcam = { pkgs, config, ... }: {
    options.custom.flatcam.enable = lib.mkEnableOption "FlatCAM";

    config = lib.mkIf config.custom.flatcam.enable {
      home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.flatcam
      ];
    };
  };
}
