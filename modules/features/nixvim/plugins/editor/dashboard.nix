{
  flake.modules.nixvim.base.plugins.dashboard = {
    enable = true;

    settings = {
      change_to_vcs_root = true;
      config = {
        footer = [
          "Made with ❤️"
        ];
        header = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        mru = {
          limit = 20;
        };
        project = {
          enable = false;
        };
        shortcut = [
          {
            action = {
              __raw = "function() Snacks.picker.files() end";
            };
            desc = "Files";
            group = "Label";
            icon = " ";
            icon_hl = "@variable";
            key = "f";
          }
          {
            action = {
              __raw = "function() Snacks.picker.recent() end";
            };
            desc = "Recent";
            group = "Label";
            icon = "🧾";
            icon_hl = "@variable";
            key = "r";
          }
          {
            action = {
              __raw = "function() Snacks.picker.grep() end";
            };
            desc = "Grep";
            group = "Label";
            icon = " ";
            icon_hl = "@variable";
            key = "g";
          }
          {
            action = {
              __raw = "function() vim.cmd[[qa]] end";
            };
            desc = "Quit";
            group = "Label";
            icon = "🚫 ";
            icon_hl = "@variable";
            key = "q";
          }
        ];
        week_header = {
          enable = false;
        };
      };
      theme = "hyper";
    };
  };
}
