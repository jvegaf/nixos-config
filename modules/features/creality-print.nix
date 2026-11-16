{ ... }: {
  flake.homeModules.creality-print = { pkgs, ... }: {
    home.packages = [
      pkgs.creality-print
    ];
  };
}
