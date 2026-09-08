{ ... }:
{
  flake.modules.nixvim.base = { pkgs, ... }: {

    keymaps = [
      {
        mode = [
          "n"
        ];
        key = "gx";
        action = "<cmd>URLOpenUnderCursor<cr>";
        options = {
          desc = "Open URL under cursor";
        };
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      url-open
    ];

    extraConfigLua = ''
      require('url-open').setup({
        open_app = 'default',
        open_only_when_cursor_on_url = false,
        highlight_url = {
          all_urls = {
            enabled = true,
            fg = '#199eff',
            underline = true,
          },
          cursor_move = {
            enabled = true,
            fg = '#21d5ff',
            underline = true,
          },
        },
      })
    '';
  };
}
