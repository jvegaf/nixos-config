{ lib, pkgs, ... }:
{

  flake.modules.nixvim.base = {

    keymaps = [
      {
        mode = "n";
        key = "<leader>=";
        action = ":FormatToggle<cr>";
        options.desc = "Toggle format-on-save";
      }
    ];

    plugins = {
      which-key = {
        enable = true;
        settings = {
          delay = 200;
          expand = 1;
          notify = false;
          preset = false;
          replace = {
            desc = [
              [
                "<space>"
                "SPACE"
              ]
              [
                "<leader>"
                "SPACE"
              ]
              [
                "<[cC][rR]>"
                "RETURN"
              ]
              [
                "<[tT][aA][bB]>"
                "TAB"
              ]
              [
                "<[bB][sS]>"
                "BACKSPACE"
              ]
            ];
          };
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
              icon = "󰓩 ";
            }
            {
              __unkeyed = "<leader>c";
              group = "Code";
              icon = "󰄄 ";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>bs";
              group = "Sort";
              icon = "󰒺 ";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
              mode = [
                "n"
                "v"
              ];
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "windows";
              proxy = "<C-w>";
            }
            {
              __unkeyed-1 = "<leader>a";
              group = "AI 👨‍🦯";
              mode = [
                "n"
                "v"
              ];
            }
            # {
            #   __unkeyed-1 = "<leader>db";
            #   __unkeyed-2 = {
            #     __raw = ''
            #       function()
            #         require("dap").toggle_breakpoint()
            #       end
            #     '';
            #   };
            #   desc = "Breakpoint toggle";
            #   mode = "n";
            #   silent = true;
            # }
          ];
          win = {
            border = "single";
          };
        };
      };
    };
  };
}
