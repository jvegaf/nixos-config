{ ... }:
{
  # Aspecto NixOS (opcional): por si algún binario descargado necesita ld dinámico
  flake.modules.nixos.gentle-shell = {
    programs.nix-ld.enable = true;
  };

  # Aspecto Home Manager
  flake.modules.homeManager.gentle-shell =
    { config, pkgs, lib, ... }:
    let
      prefix = "${config.home.homeDirectory}/.npm-global";
    in
    {
      home.packages = [ pkgs.nodejs ];
      home.sessionVariables.NPM_CONFIG_PREFIX = prefix;
      home.sessionPath = [ "${prefix}/bin" ];

      # Opcional: instala gentle-pi la primera vez (requiere red en el switch)
      home.activation.gentleShell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${pkgs.nodejs}/bin:$PATH"
        export NPM_CONFIG_PREFIX="${prefix}"
        if [ ! -x "${prefix}/bin/gentle-shell" ]; then
          $DRY_RUN_CMD npm i -g gentle-pi || true
        fi
      '';
    };
}
