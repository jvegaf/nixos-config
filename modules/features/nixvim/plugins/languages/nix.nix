{
  flake.modules.nixvim.base = {
    plugins = {
      nix.enable = true;
      nix-develop.enable = true;
      lsp.servers.nil_ls.enable = true;

      conform-nvim.settings.formatters_by_ft.nix = ["nixfmt"];
    };
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixfmt
      ];
      programs.git.ignores = [
        "result"
        "result/*"
      ];
    };
}
