{
  flake.modules.nixvim.base = {
    plugins.oil = {
      enable = true;

      settings = {
        default_file_explorer = false;

        float = {
          max_height = 75;
          max_width = 75;
        };

        view_options.show_hidden = true;
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>E";
        action = "<cmd>lua if vim.bo.filetype == 'oil' then vim.cmd('bd') else require('oil').open_float() end<cr>";
        options.desc = "Toggle Oil Explorer";
      }
    ];
  };
}
