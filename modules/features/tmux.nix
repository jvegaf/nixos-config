{
  self,
  pkgs,
  ...
}:

let
  mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;

  tmuxCommandPalette = mkTmuxPlugin {
    pluginName = "tmux-command-palette";
    version = "unstable-2026-07-07";
    rtpFilePath = "init.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "lost-melody";
      repo = "tmux-command-palette";
      rev = "82a65a8278158f2a84bf1e01f03970bd3f696562";
      hash = "sha256-MHO/6eU0gNd8sF8yjjcNEGOtmXGMSwql5lahZq3+kNc=";
    };
  };

  tmux2k = mkTmuxPlugin {
    pluginName = "tmux2k";
    version = "unstable-2026-07-07";
    rtpFilePath = "2k.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "2KAbhishek";
      repo = "tmux2k";
      rev = "ce1550aefaccf2cad709b1add64c6c0cf4299092";
      hash = "sha256-qGe06yNmJ8GYtOwBEU2ZChrWdYXuVDsdE9MEouqzmKc=";
    };
  };

  tmuxAutoreload = mkTmuxPlugin {
    pluginName = "tmux-autoreload";
    version = "unstable-2026-07-07";
    rtpFilePath = "tmux-autoreload.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "tmux-autoreload";
      rev = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
      hash = "sha256-9Rk+VJuDqgsjc+gwlhvX6uxUqpxVD1XJdQcsc5s4pU4=";
    };
  };

  tmuxGh = mkTmuxPlugin {
    pluginName = "tmux-gh";
    version = "unstable-2026-07-07";
    rtpFilePath = "tmux_gh.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "tardunge";
      repo = "tmux-gh";
      rev = "e66c52bc200744b99209ce42bb483aeaa34e04f5";
      hash = "sha256-7qOIPIiI5c4FsgMzcce/EoYHF2AfeyPS69jTuFf25xU=";
    };
  };

  tmuxGentrify = mkTmuxPlugin {
    pluginName = "tmux-gentrify";
    version = "unstable-2026-07-07";
    rtpFilePath = "plugin.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "kristopolous";
      repo = "tmux-gentrify";
      rev = "46eabde31c6a19ea11f6a6d48e7aa0e8567f13b4";
      hash = "sha256-iYoz2eqONtVdgO2M8RRrJKWM/JFFqIpI9xuxlXvrUzU=";
    };
  };

  tmuxNotify = mkTmuxPlugin {
    pluginName = "tmux-notify";
    version = "unstable-2026-07-07";
    rtpFilePath = "tnotify.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "rickstaa";
      repo = "tmux-notify";
      rev = "b713320af05837c3b44e4d51167ff3062dbeae4b";
      hash = "sha256-wOmq2stWXAFmYrRuIqf9IPATYXJ+OFoYXnJdHUnJQxY=";
    };
  };

  tmuxCowboy = mkTmuxPlugin {
    pluginName = "tmux-cowboy";
    version = "unstable-2026-07-07";
    rtpFilePath = "cowboy.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cowboy";
      rev = "75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      hash = "sha256-KJNsdDLqT2Uzc25U4GLSB2O1SA/PThmDj9Aej5XjmJs=";
    };
  };

  tmuxTilit = mkTmuxPlugin {
    pluginName = "tmux-tilit";
    version = "unstable-2026-07-07";
    rtpFilePath = "tilit.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "2KAbhishek";
      repo = "tmux-tilit";
      rev = "c73bd10cb598fae057309b8e4aa058df86d3ce94";
      hash = "sha256-iG09jgU1CnI4GGoEZtg0Dn+0FfkJN4OyHjpZNfDdci0=";
    };
  };
in
{

  flake.homeModules.tmux =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.tmux-which-key.homeManagerModules.default
      ];

      programs.tmux = {
        # this is where plugins should go
        enable = true;
        baseIndex = 1;
        clock24 = true;
        escapeTime = 0;
        historyLimit = 50000;
        keyMode = "vi";
        mouse = true;
        shortcut = "Space"; # CTRL following by this key is used as the main shortcut
        terminal = "tmux-256color";
        plugins = with pkgs.tmuxPlugins; [
          # Baseline sane tmux defaults.
          sensible

          # Copy tmux selections into the system clipboard.
          # Needs wl-clipboard on Wayland, xclip/xsel on X11.
          yank

          # Save sessions, windows, panes, and layouts.
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-capture-pane-contents 'on'
              set -g @resurrect-strategy-vim 'session'
              set -g @resurrect-strategy-nvim 'session'
            '';
          }

          # Auto-save tmux state and restore on tmux server start.
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '15'
            '';
          }

          # Better mouse selection and scrolling behavior.
          better-mouse-mode

          # Search visible pane text with fzf and paste selected results.
          extrakto

          # Fuzzy-pick URLs from pane history and open them.
          fzf-tmux-url

          # Fuzzy-search scrollback with fzf.
          {
            plugin = fuzzback;
            extraConfig = ''
              set -g @fuzzback-bind 'F'
              set -g @fuzzback-popup '1'
              set -g @fuzzback-popup-size '90%'
            '';
          }

          # Toggle floating scratch panes/popups for quick side tasks.
          {
            plugin = tmux-floax;
            extraConfig = ''
              set -g @floax-bind 'f'
              set -g @floax-width '85%'
              set -g @floax-height '85%'
              set -g @floax-change-path 'true'
            '';
          }
          {
            plugin = tmux-toggle-popup;
            extraConfig = ''
              set -g @toggle-popup-key 'C-g'
              set -g @toggle-popup-command 'lazygit'
            '';
          }

          # Capture pane and session logs when needed.
          logging

          # tmux2k owns the status bar, including CPU/RAM/readability.
          {
            plugin = tmux2k;
            extraConfig = ''
              set -g @tmux2k-theme 'onedark'
              set -g @tmux2k-left-plugins 'session git'
              set -g @tmux2k-right-plugins 'github cpu ram battery network time'
              set -g @tmux2k-refresh-rate '5'
              set -g @tmux2k-session-icon 'help C-Space enter'
              set -g @tmux2k-git-display-status 'true'
              set -g @tmux2k-cpu-gradient 'heat'
              set -g @tmux2k-cpu-icon-link-to 'usage'
              set -g @tmux2k-ram-gradient 'heat'
              set -g @tmux2k-ram-icon-link-to 'usage'
              set -g @tmux2k-time-format '%Y-%m-%d %H:%M'
            '';
          }

          # Show when prefix has been pressed.
          {
            plugin = prefix-highlight;
            extraConfig = ''
              set -g @prefix_highlight_show_copy_mode 'on'
            '';
          }

          # Lightweight status-bar signal plugins not covered by tmux2k.
          online-status
          tmuxGh

          # Fuzzy session picker with previews, rename, delete, and zoxide-style workflows.
          {
            plugin = tmux-sessionx;
            extraConfig = ''
              set -g @sessionx-bind 'o'
              set -g @sessionx-fzf-builtin-tmux 'on'
              set -g @sessionx-zoxide-mode 'on'
              set -g @sessionx-ls-command 'eza --tree --icons=auto --color=always'
            '';
          }

          # Session management helpers for creating, switching, and promoting sessions.
          sessionist

          # Toggle a directory tree sidebar.
          {
            plugin = sidebar;
            extraConfig = ''
              set -g @sidebar-tree-command 'eza --tree --icons=auto --color=always'
            '';
          }

          # Keybinding/command palette with fzf-backed selection.
          {
            plugin = tmuxCommandPalette;
            extraConfig = ''
              set -g @cmdpalette-render-cmd 'mdcat'
              set -g @cmdpalette-key-prefix 'prefix enter'
              set -g @cmdpalette-cmd-commands 'prefix P'
            '';
          }

          # Reload tmux configuration when Home Manager rewrites it.
          {
            plugin = tmuxAutoreload;
            extraConfig = ''
              set -g @tmux-autoreload-entrypoints '1'
              set -g @tmux-autoreload-quiet '1'
            '';
          }

          # Move panes between windows with a small cut/paste stack.
          tmuxGentrify

          # Desktop notifications for long-running pane commands.
          {
            plugin = tmuxNotify;
            extraConfig = ''
              set -g @tnotify-verbose 'on'
            '';
          }

          # Tiling-window-manager style Alt bindings for panes/windows.
          {
            plugin = tmuxTilit;
            extraConfig = ''
              set -g @tilit-mod 'M-'
              set -g @tilit-navigator 'on'
              set -g @tilit-autotiling 'on'
            '';
          }

          # Force-kill the foreground process in the current pane.
          tmuxCowboy

        ];

        tmux-which-key = {
          enable = true;

          # The default config only binds `prefix + Space`; `root_table` is
          # commented out upstream. Extend the default settings to also bind
          # Ctrl+Space without a prefix.
          settings =
            let
              defaultSettings = import "${inputs.tmux-which-key}/nix/generate-config.nix" {
                inherit lib pkgs;
              };
            in
            defaultSettings
            // {
              keybindings = defaultSettings.keybindings // {
                root_table = "C-Space";
              };
            };

          # The upstream plugin script uses GNU-only `realpath --relative-to`,
          # which fails with macOS BSD realpath and aborts before loading the
          # plugin. Patch it to use GNU realpath from coreutils directly.
          package =
            inputs.tmux-which-key.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
              (old: {
                postInstall = (old.postInstall or "") + ''
                  substituteInPlace $out/share/tmux-plugins/tmux-which-key/plugin.sh.tmux \
                    --replace-fail 'realpath --relative-to' '${pkgs.coreutils}/bin/realpath --relative-to'
                '';
              });
        };

        tmux-which-key = {
          enable = true;

          settings = {
            command_alias_start_index = 200;
            custom_variables = [ ];
            macros = [ ];

            keybindings = {
              prefix_table = "Space";
              # root_table = "C-Space"; # leave off at first
            };

            title = {
              prefix = "tmux";
              style = "align=centre,bold";
              prefix_style = "fg=green,align=centre,bold";
            };

            position = {
              x = "C";
              y = "C";
            };

            items = [
              {
                name = "Next pane";
                key = "Space";
                command = "next-pane";
              }

              { separator = true; }

              {
                name = "+Panes";
                key = "p";
                menu = [
                  {
                    name = "Split horizontal";
                    key = "/";
                    command = "split-window -v -c \"#{pane_current_path}\"";
                  }
                  {
                    name = "Split vertical";
                    key = "-";
                    command = "split-window -h -c \"#{pane_current_path}\"";
                  }
                  {
                    name = "Zoom pane";
                    key = "z";
                    command = "resize-pane -Z";
                  }
                  {
                    name = "Kill pane";
                    key = "x";
                    command = "confirm-before -p \"kill pane #P?\" kill-pane";
                  }
                ];
              }

              {
                name = "+Sessions";
                key = "s";
                menu = [
                  {
                    name = "Sessionx picker";
                    key = "s";
                    command = "run-shell \"${pkgs.tmuxPlugins.tmux-sessionx}/share/tmux-plugins/sessionx/scripts/sessionx.sh\"";
                  }
                  {
                    name = "Save session";
                    key = "S";
                    command = "run-shell \"${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh\"";
                  }
                  {
                    name = "Restore session";
                    key = "R";
                    command = "run-shell \"${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh\"";
                  }
                  {
                    name = "Create session";
                    key = "C";
                    command = "command-prompt -p \"New session:\" \"new-session -d -s '%%'\" \\; switch-client -t '%%'";
                  }
                  {
                    name = "Switch/create session";
                    key = "g";
                    command = "command-prompt -p \"Session:\" \"new-session -A -s '%%'\"";
                  }
                  {
                    name = "Promote pane to session";
                    key = "@";
                    command = "break-pane";
                  }
                ];
              }

              {
                name = "+Tools";
                key = "t";
                menu = [
                  {
                    name = "Lazygit";
                    key = "g";
                    command = "display-popup -d \"#{pane_current_path}\" -w 90% -h 90% -E \"lazygit\"";
                  }
                  {
                    name = "Floating shell";
                    key = "f";
                    command = "display-popup -d \"#{pane_current_path}\" -w 85% -h 85% -E \"$SHELL\"";
                  }
                  {
                    name = "Search pane text";
                    key = "e";
                    command = "run-shell \"${pkgs.tmuxPlugins.extrakto}/share/tmux-plugins/extrakto/scripts/open.sh\" \"#{pane_id}\"";
                  }
                  {
                    name = "Open URL";
                    key = "u";
                    command = "run-shell \"${pkgs.tmuxPlugins.fzf-tmux-url}/share/tmux-plugins/fzf-tmux-url/fzf-url.sh\"";
                  }
                  {
                    name = "Search scrollback";
                    key = "F";
                    command = "run-shell \"${pkgs.tmuxPlugins.fuzzback}/share/tmux-plugins/fuzzback/scripts/fuzzback.sh\"";
                  }
                  {
                    name = "Command palette";
                    key = "enter";
                    command = "display-message \"Use C-Space enter for command palette\"";
                  }
                  {
                    name = "Sidebar";
                    key = "Tab";
                    command = "run-shell \"${pkgs.tmuxPlugins.sidebar}/share/tmux-plugins/sidebar/sidebar.tmux\"";
                  }
                  {
                    name = "Monitor pane";
                    key = "m";
                    command = "display-message \"Use C-Space m to notify when this pane finishes\"";
                  }
                  {
                    name = "Cancel monitor";
                    key = "M";
                    command = "display-message \"Use C-Space M to cancel pane monitoring\"";
                  }
                  {
                    name = "GitHub account";
                    key = "G";
                    command = "display-message \"GitHub: #{tmux_gh_uname}\"";
                  }
                  {
                    name = "Kill pane process";
                    key = "*";
                    command = "display-message \"Use C-Space * to kill the pane process\"";
                  }
                ];
              }

              {
                name = "+Tiling";
                key = "a";
                menu = [
                  {
                    name = "Alt bindings";
                    key = "a";
                    command = "display-message \"tmux-tilit uses Alt as its direct pane/window prefix\"";
                  }
                  {
                    name = "Cut pane";
                    key = "x";
                    command = "display-message \"Use C-Space M-x to cut pane with gentrify\"";
                  }
                  {
                    name = "Paste pane";
                    key = "v";
                    command = "display-message \"Use C-Space M-v to paste pane with gentrify\"";
                  }
                ];
              }

              { separator = true; }

              {
                name = "Copy mode";
                key = "[";
                command = "copy-mode";
              }
            ];
          };
        };

        extraConfig = ''
          ##### general #####


          ##### lazygit #####

          # Simple lazygit popup. This may be enough without neolazygit.
          bind-key g display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "lazygit"


          ##### status bar #####

          set -g status on
          set -g status-interval 5
          set -g status-right-length 140

          set -g status-left '#{prefix_highlight} #[bold]help C-Space enter #[default] #S '
        '';
      };

      home.shellAliases = {
        mx = "tmux";
      };
    };
}
