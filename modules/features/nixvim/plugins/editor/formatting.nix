{
  flake.modules.nixvim.base = { lib, pkgs, ... }: {
    autoCmd = [
      {
        desc = "Automatically trim all whitespace an save";
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
        command = ":%s/\\s\\+$//e";
      }
    ];

    keymaps = [
      {
        mode = [ "v" ];
        key = "<leader>o";
        action = ":sort<cr>";
        options.desc = "Sort Selected";
      }
    ];

    plugins.conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          lua = [ "stylua" ];
          json = [ "jq" ];
          rust = [ "rustfmt" ];
          c = [ "clang_format" ];
          cpp = [ "clang_format" ];
          bash = [ "shfmt" ];
          "_" = [
            "trim_newlines"
            "trim_whitespace"
          ];
        };
        formatters = {
          clang_format.command = lib.getExe' pkgs.clang-tools "clang-format";
          stylua.command = lib.getExe pkgs.stylua;
          shfmt.command = lib.getExe pkgs.shfmt;
          nixfmt.command = lib.getExe pkgs.nixfmt;
        };
        format_on_save = # Lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 500, lsp_format = "fallback" }
             end
          '';
        default_format_opts = {
          lsp_format = "fallback";
        };
      };
    };
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.prettierd ];
    };
}
