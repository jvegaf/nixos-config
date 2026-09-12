{ self, inputs, lib, ... }:
let
  settings = import ../../../lib/opencode/settings.nix;
  mkConfigDir = import ../../../lib/opencode/config.nix;
in
{
  flake.wrappers.opencode =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.opencode ];

      settings = settings // {
        "$schema" = "https://opencode.ai/config.json";
        context = [ "AGENTS.md" ];
      };

      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

      envDefault.OPENCODE_CONFIG_DIR = mkConfigDir {
        inherit inputs lib pkgs;
      };

      runtimePkgs = with pkgs; [
        nixd
        vscode-langservers-extracted
        svelte-language-server
        emmet-language-server
        haskell-language-server
        python312Packages.python-lsp-server
        lua-language-server
        yaml-language-server
      ];
    };

  flake.homeModules.opencode =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.opencode ];
    };
}
