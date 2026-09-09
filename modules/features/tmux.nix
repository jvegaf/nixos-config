{
  ...
}:
{
  flake.wrappers.tmux =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.tmux ];

      prefix = "M-a";
      terminal = "tmux-256color";
      modeKeys = "vi";
      statusKeys = "vi";
      mouse = true;
      disableConfirmationPrompt = false;

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = vim-tmux-navigator;
          configBefore = ''
            set -g @vim_navigator_no_mappings 1
          '';
          configAfter = ''
            is_vim="ps -o state = -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ]+ +(\S+\/)?g?(view|n?vim?x?)(diff)?$'"
            bind-key -n C-w if-shell "$is_vim" "send-keys C-w" "switch-client -T vimtable"
            bind-key -T vimtable h select-pane -L \; switch-client -T root
            bind-key -T vimtable j select-pane -D \; switch-client -T root
            bind-key -T vimtable k select-pane -U \; switch-client -T root
            bind-key -T vimtable l select-pane -R \; switch-client -T root
          '';
        }
        {
          plugin = tmux-fzf;
          configBefore = ''
            TMUX_FZF_LAUNCH_KEY="Space"
          '';
        }
        {
          plugin = catppuccin;
          configBefore = ''
            set -g @catppuccin_flavor 'mocha'
          '';
        }
        {
          plugin = tmux-which-key;
          configBefore = ''
            # Enables XDG user directory support for the plugin.
            set -g @tmux-which-key-xdg-enable 1;

            # The home manager module calls `plugin/build.py` on each generation.
            set -g @tmux-which-key-disable-autobuild 1

            set -g @tmux-which-key-xdg-plugin-path tmux-plugins/tmux-which-key
          '';
        }
        {
          plugin = mode-indicator;
          configBefore = ''
            set -g status-right '%Y-%m-%d %H:%M #{tmux_mode_indicator}'
          '';
        }
      ];

      configAfter = ''
        # kill sessions easily
        bind X confirm-before kill-session

        unbind %

        bind c new-window -c "#{pane_current_path}"
        bind '-' split-window -c "#{pane_current_path}"
        unbind .
        bind . split-window -h -c "#{pane_current_path}"

        bind x kill-pane
        bind e kill-window
        bind -n M-Q kill-session

        bind j resize-pane -D 5
        bind k resize-pane -U 5
        bind l resize-pane -R 5
        bind h resize-pane -L 5

        bind -r m resize-pane -Z

        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection

        unbind -T copy-mode-vi MouseDragEnd1Pane

        set-option -g status-position top
      '';
    };
}
