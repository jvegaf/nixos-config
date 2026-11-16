{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "flatcam";
  version = "2024.4";

  src = fetchurl {
    url = "https://github.com/vika-sonne/FlatCAM/releases/download/v${version}/flatcam-${version}-x86_64.AppImage";
    hash = "sha256-vde7tEjf+QU7KxQVMfQ+5ES2H7jAVSbTJP/D3Y6s7sI=";
  };

  contents = appimageTools.extract rec {
    inherit pname version src;

    postExtract = ''
      # The FHS sandbox /bin/sh loads the AppImage's bundled (old) libreadline and
      # dies with an undefined symbol, so avoid FlatCAM calling sh via os.system().
      sed -i \
        "s|os.system('rm /tmp/testipc')|os.remove('/tmp/testipc') if os.path.exists('/tmp/testipc') else None|" \
        "$out/usr/src/FlatCAM/app_Main.py"

      # Use the bundled fonts together with the bundled (old) fontconfig config,
      # which the host system's fontconfig.conf cannot express.
      sed -i \
        "s|</fontconfig>|<dir>$out/usr/share/fonts</dir>\n</fontconfig>|" \
        "$out/etc/fonts/fonts.conf"

      # The apprun runtime overwrites MPLCONFIGDIR from AppRun.env with a
      # read-only path, forcing matplotlib to fall back to a temp dir. Point it
      # at a writable dir under $HOME instead.
      sed -i \
        "s|MPLCONFIGDIR=\$APPDIR/usr/share/matplotlib/matplotlib.conf|MPLCONFIGDIR=\$HOME/.cache/flatcam/matplotlib|" \
        "$out/AppRun.env"
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version contents;

  profile = ''
    export PYTHONWARNINGS="ignore:A NumPy version"
    export FONTCONFIG_PATH=${contents}/etc/fonts
  '';

  extraPkgs = pkgs: with pkgs; [
    libxcb
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxkbcommon
    libGL
  ];

  meta = with lib; {
    description = "2-D post processing for PCB fabrication on CNC routers";
    homepage = "https://github.com/vika-sonne/FlatCAM";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "flatcam";
  };
}
