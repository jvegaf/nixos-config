{ self, config, ... }: {
  flake.homeModules.creality-print = { pkgs, lib, ... }: {
    options.custom.creality-print.enable = lib.mkEnableOption "Creality Print Slicer";

    config = lib.mkIf config.custom.creality-print.enable {
      home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.creality-print
      ];
    };
  };
}
