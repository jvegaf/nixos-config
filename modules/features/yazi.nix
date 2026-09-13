{

  flake.homeModules.yazi =
{
  config,
  lib,
  pkgs,
  ...
}:
    {
  # yazi file manager
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = config.programs.zsh.enable;
    initLua = ''
      require("gvfs"):setup({})

      require("git"):setup()
      require("starship"):setup()

      local old_build = Tab.build
      Tab.build = function(self, ...)
          local bar = function(c, x, y)
              if x <= 0 or x == self._area.w - 1 then
                  return ui.Bar(ui.Bar.TOP):area(ui.Rect.default)
              end

              return ui.Bar(ui.Bar.TOP)
                  :area(ui.Rect({
                      x = x,
                      y = math.max(0, y),
                      w = ya.clamp(0, self._area.w - x, 1),
                      h = math.min(1, self._area.h),
                  }))
                  :symbol(c)
          end

          local c = self._chunks
          self._chunks = {
              c[1]:pad(ui.Pad.y(1)),
              c[2]:pad(ui.Pad(1, c[3].w > 0 and 0 or 1, 1, c[1].w > 0 and 0 or 1)),
              c[3]:pad(ui.Pad.y(1)),
          }

          local style = th.mgr.border_style
          self._base = ya.list_merge(self._base or {}, {
              -- Enable for full border
              --[[ ui.Border(self._area, ui.Border.ALL):type(ui.Border.ROUNDED):style(style), ]]
              ui.Bar(ui.Bar.RIGHT):area(self._chunks[1]):style(style),
              ui.Bar(ui.Bar.LEFT):area(self._chunks[1]):style(style),

              bar(" ", c[1].right - 1, c[1].y),
              bar(" ", c[1].right - 1, c[1].bottom - 1),
              bar(" ", c[2].right, c[2].y),
              bar(" ", c[2].right, c[1].bottom - 1),
          })

          old_build(self, ...)
        end
    '';
    plugins = {
      inherit (pkgs.yaziPlugins) gvfs chmod git mediainfo starship;
    };

    keymap = {
      cmp.prepend_keymap = [
        {
          on = [ "~" ];
          run = "help";
          desc = "Open help";
        }
      ];

      mgr.prepend_keymap = [
        {
          on = [ "q" ];
          run = "close";
          desc = "Close the current tab; if it's the last tab, exit the process instead.";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ~/Nextcloud";
          desc = "Go to Nextcloud";
        }
        {
          run = "plugin gvfs -- select-then-mount jump";
          on = [
            "M"
            "m"
          ];
          desc = "Mount and jump to device";
        }
        {
          run = "plugin gvfs -- select-then-unmount --eject";
          on = [
            "M"
            "u"
          ];
          desc = "Unmount and eject device";
        }
        {
          run = "plugin gvfs -- jump-to-device";
          on = [
            "g"
            "m"
          ];
          desc = "Jump to mounted device";
        }
        {
          run = "plugin chmod";
          on = [
            "c"
            "m"
          ];
          desc = "Chmod on selected files";
        }
        {
          run = "tab_switch 1 --relative";
          on = [ "<C-Tab>" ];
        }
        {
          run = "tab_switch -1 --relative";
          on = [ "<C-BackTab>" ];
        }
        # drop to shell
        {
          on = "!";
          run = ''shell "$SHELL" --block'';
          desc = "Open shell here";
        }
        # Run ripdrag when pressing C-n
        {
          run = ''shell '${lib.getExe pkgs.ripdrag} "$@" -x 2>/dev/null &' --confirm'';
          on = [ "<C-n>" ];
        }
      ];
    };

    settings = {
      mgr = {
        layout = [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };

      pick = {
        open_title = "Open with:";
        open_origin = "hovered";
        open_offset = [
          0
          1
          50
          7
        ];
      };

      preview = {
        tab_size = 2;
        max_width = 1024;
        max_height = 1920;
        cache_dir = "${config.xdg.cacheHome}";
      };

      # Prevent yazi from freezing while preloading/previewing files over slow
      # gvfs mounts (MTP, remote filesystems, etc.)
      plugin = {
        prepend_preloaders = [
          {
            url = "/run/user/1000/gvfs/**/*";
            run = "noop";
          }
        {
          mime = "{audio,video,image}/*";
          run = "mediainfo";
        }
        {
          mime = "application/subrip";
          run = "mediainfo";
        }
        {
          mime = "application/postscript";
          run = "mediainfo";
        }
        ];
        prepend_previewers = [
          {
            url = "*/";
            run = "folder";
          }
          {
            url = "/run/user/1000/gvfs/**/*";
            run = "noop";
          }
        {
          mime = "{audio,video,image}/*";
          run = "mediainfo";
        }
        {
          mime = "application/subrip";
          run = "mediainfo";
        }
        {
          mime = "application/postscript";
          run = "mediainfo";
        }
        ];
      prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
      };
    };
  };
  };
}
