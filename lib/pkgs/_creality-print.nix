{
  lib,
  appimageTools,
  fetchurl,
  pkgs,
}:

let
  version = "7.2.1";
  build = "5476";
  pname = "creality-print"; # Cambiado a minúsculas según la convención de Nix

  src = fetchurl {
    url = "https://github.com/CrealityOfficial/CrealityPrint/releases/download/v${version}/CrealityPrint-V${version}.${build}-x86_64-Release.AppImage";
    hash = "sha256-so9mwl0MZlLtauSdB2Z4D0aluDm5POGWjmOYI+H24vM=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;

    postExtract = ''
      substituteInPlace $out/AppRun \
        --replace-fail \
          'export LD_LIBRARY_PATH="$DIR/bin:$DIR/usr/lib"' \
          'export LD_LIBRARY_PATH="$DIR/bin:$DIR/usr/lib:/usr/lib64:${lib.getLib pkgs.bzip2}/lib:$LD_LIBRARY_PATH"'
    '';
  };
in
appimageTools.wrapAppImage rec {
  inherit pname version src;
  contents = appimageContents;

  # Añade este bloque para proporcionar las dependencias dinámicas que falten
  extraPkgs =
    pkgs: with pkgs; [
      libdeflate
      libsoup_3
      webkitgtk_4_1
      bzip2
      zstd
    ];

  extraInstallCommands = ''
    # 1. Crear el directorio e instalar el archivo .desktop extraído del AppImage
    install -m 444 -D ${appimageContents}/CrealityPrint.desktop -t $out/share/applications

    # Opcional pero recomendado: Instalar el icono para que se vea en el sistema. 
    # (Nota: Verifica si dentro del AppImage el icono se llama CrealityPrint.png, .svg, o de otra forma)
    install -m 444 -D ${appimageContents}/CrealityPrint.png -t $out/share/icons/hicolor/256x256/apps || true

    # 2. Ahora sí podemos parchear el archivo porque ya existe en $out
    substituteInPlace $out/share/applications/CrealityPrint.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}' \
      --replace-fail 'Icon=CrealityPrint' 'Icon=CrealityPrint' # Ajusta si el nombre del icono cambia
  '';

  meta = {
    description = "FDM slicing software produced by Shenzhen Creality 3D Technology Co.";
    homepage = "https://github.com/CrealityOfficial/CrealityPrint";
    downloadPage = "https://github.com/CrealityOfficial/CrealityPrint/releases";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname; # Declarado para que la sustitución funcione sin fallos
  };
}
