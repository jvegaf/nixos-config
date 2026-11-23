{ ... }:
{
  flake.modules.nixvim.base = { pkgs, ... }: {

    # keymaps = [
    #   {
    #     mode = [
    #       "n"
    #     ];
    #     key = "gx";
    #     action = "<cmd>URLOpenUnderCursor<cr>";
    #     options = {
    #       desc = "Open URL under cursor";
    #     };
    #   }
    # ];

    extraPlugins = with pkgs.vimPlugins; [
      pantran-nvim
    ];

    extraConfigLua = ''
      local pantran = require('pantran')
      local opts = { noremap = true, silent = true, expr = true }
      vim.keymap.set('n', '<leader>tr', pantran.motion_translate, opts)
      vim.keymap.set('n', '<leader>trr', function()
        return pantran.motion_translate() .. '_'
      end, opts)
      vim.keymap.set('x', '<leader>tr', pantran.motion_translate, opts)
      -- gr for replace by translation
      -- gt for change target language

      pantran.setup({
        default_engine = 'google',
        default_target = 'en',
      })

    '';
  };
}
