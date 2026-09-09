{
  flake.homeModules.orcaslicer =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      # Ruta absoluta a tu repositorio de dotfiles
      dotfilesDir = "/home/th3g3ntl3man/nixos-config";
    in
    {
      options.custom.orcaslicer.enable = lib.mkEnableOption "OrcaSlicer 3D Slicer";

      config = lib.mkIf config.custom.orcaslicer.enable {
        home.packages = [ pkgs.orca-slicer ];

        # Enlace simbólico fuera del Nix Store
        home.file.".config/OrcaSlicer".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/features/orcaslicer/OrcaSlicer";
      };
    };
}
