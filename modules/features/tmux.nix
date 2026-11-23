{
  flake.homeModules.tmux =
    { pkgs, lib, ... }:
    let
      mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;

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

      programs.tmux = {
        enable = true;
        baseIndex = 1;
        mouse = true;
        prefix = "C-a";
        keyMode = "vi";
        sensibleOnTop = true;
        terminal = "tmux-256color";
        extraConfig = ''
          set -as terminal-features ",alacritty*:RGB"

          bind C-Left resize-pane -L 5
          bind C-Right resize-pane -R 5
          bind C-Up resize-pane -U 3
          bind C-Down resize-pane -D 3

          unbind r
          bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

          bind c new-window -c "#{pane_current_path}"
          bind '-' split-window -c "#{pane_current_path}"
          unbind .
          bind . split-window -h -c "#{pane_current_path}"

          bind x kill-pane
          bind e kill-window
          bind -n M-Q kill-session

          set -g status-keys vi
          bind-key -T  copy-mode-vi 'y' send -X begin-selection
          bind-key -T  copy-mode-vi 'y' send -X copy-selection

          set -g status-position "top"
        '';
        plugins = with pkgs; [
          tmuxPlugins.yank
          {
            plugin = tmuxPlugins.vim-tmux-navigator;
            extraConfig = ''
              set -g @vim_navigator_no_mappings 1
              is_vim="ps -o state = -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ]+ +(\S+\/)?g?(view|n?vim?x?)(diff)?$'"
              bind-key -n C-w if-shell "$is_vim" "send-keys C-w" "switch-client -T vimtable"
              bind-key -T vimtable h select-pane -L \; switch-client -T root
              bind-key -T vimtable j select-pane -D \; switch-client -T root
              bind-key -T vimtable k select-pane -U \; switch-client -T root
              bind-key -T vimtable l select-pane -R \; switch-client -T root
            '';
          }
          {
            plugin = tmuxPlugins.tmux-fzf;
            extraConfig = ''
              TMUX_FZF_LAUNCH_KEY="Space"
            '';
          }
          {
            plugin = tmuxPlugins.tmux-which-key;
            extraConfig = ''
              # Enables XDG user directory support for the plugin.
              set -g @tmux-which-key-xdg-enable 1;

              # The home manager module calls `plugin/build.py` on each generation.
              set -g @tmux-which-key-disable-autobuild 1

              set -g @tmux-which-key-xdg-plugin-path tmux-plugins/tmux-which-key
            '';
          }
          {
            plugin = tmuxPlugins.mode-indicator;
            extraConfig = ''
              set -g status-left '#{tmux_mode_indicator}'
            '';
          }
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = ''
              set -g @resurrect-capture-pane-contents 'on'
              set -g @resurrect-strategy-vim 'session'
              set -g @resurrect-strategy-nvim 'session'
            '';
          }
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60' # minutes
            '';
          }
          {
            plugin = tmuxPlugins.fingers;
            extraConfig = ''
              set -g @fingers-main-action ':open:'
              set -g @fingers-alt-action ':copy:'
              bind e run -b "#{@fingers-cli} start #{pane_id} --patterns url"
              set -g @fingers-show-copied-notification true
            '';
          }
          # Better mouse selection and scrolling behavior.
          tmuxPlugins.better-mouse-mode

          # Search visible pane text with fzf and paste selected results.
          tmuxPlugins.extrakto

          # Fuzzy-pick URLs from pane history and open them.
          tmuxPlugins.fzf-tmux-url

          # Fuzzy-search scrollback with fzf.
          {
            plugin = tmuxPlugins.fuzzback;
            extraConfig = ''
              set -g @fuzzback-bind 'F'
              set -g @fuzzback-popup '1'
              set -g @fuzzback-popup-size '90%'
            '';
          }

          # Toggle floating scratch panes/popups for quick side tasks.
          {
            plugin = tmuxPlugins.tmux-floax;
            extraConfig = ''
              set -g @floax-bind 'f'
              set -g @floax-width '85%'
              set -g @floax-height '85%'
              set -g @floax-change-path 'true'
            '';
          }
          {
            plugin = tmuxPlugins.tmux-toggle-popup;
            extraConfig = ''
              set -g @toggle-popup-key 'C-g'
              set -g @toggle-popup-command 'lazygit'
            '';
          }

          # Capture pane and session logs when needed.
          tmuxPlugins.logging

          # tmux2k owns the status bar, including CPU/RAM/readability.
          {
            plugin = tmux2k;
            extraConfig = ''
              set -g @tmux2k-theme 'onedark'
              set -g @tmux2k-left-plugins 'time session git'
              set -g @tmux2k-right-plugins 'github cpu ram battery network'
              set -g @tmux2k-refresh-rate '5'
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
            plugin = tmuxPlugins.prefix-highlight;
            extraConfig = ''
              set -g @prefix_highlight_show_copy_mode 'on'
            '';
          }

          # Lightweight status-bar signal plugins not covered by tmux2k.
          tmuxPlugins.online-status
          tmuxGh

          # Fuzzy session picker with previews, rename, delete, and zoxide-style workflows.
          {
            plugin = tmuxPlugins.tmux-sessionx;
            extraConfig = ''
              set -g @sessionx-bind 'o'
              set -g @sessionx-fzf-builtin-tmux 'on'
              set -g @sessionx-zoxide-mode 'on'
              set -g @sessionx-ls-command 'eza --tree --icons=auto --color=always'
            '';
          }

          # Session management helpers for creating, switching, and promoting sessions.
          tmuxPlugins.sessionist

          # Toggle a directory tree sidebar.
          {
            plugin = tmuxPlugins.sidebar;
            extraConfig = ''
              set -g @sidebar-tree-command 'eza --tree --icons=auto --color=always'
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
      };

      home.shellAliases = {
        mx = "tmux";
      };
    };
}
