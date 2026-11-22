{
  self,
  ...
}:
{

  flake.homeModules.tmux = { pkgs, lib, ... }: {

    home.file.".local/bin/tmux-status".source = ./tmux-status;

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
        # set -g status-justify "centre"
        # set -g status "on"
        # set -g status-left-style "none"
        # set -g message-command-style "fg=#c5cdd9,bg=#404455"
        # set -g status-right-style "none"
        # set -g pane-active-border-style "fg=#6cb6eb"
        # set -g status-style "none,bg=#333644"
        # set -g message-style "fg=#c5cdd9,bg=#404455"
        # set -g pane-border-style "fg=#404455"
        # set -g status-right-length "100"
        # set -g status-left-length "100"
        # setw -g window-status-activity-style "none,fg=#6cb6eb,bg=#333644"
        # setw -g window-status-separator ""
        # setw -g window-status-style "none,fg=#c5cdd9,bg=#333644"
        # set -g status-right '#(~/.local/bin/tmux-status)'
        # set -g status-left '#{tmux_mode_indicator}'
        # setw -g window-status-format "#[fg=#333644,bg=#333644,nobold,nounderscore,noitalics]#[fg=#c5cdd9] #I  #W #[fg=#333644,bg=#333644,nobold,nounderscore,noitalics]"
        # setw -g window-status-current-format "#[fg=#333644,bg=#404455,nobold,nounderscore,noitalics]#[fg=#c5cdd9,bg=#404455] #I  #W  #F #[fg=#404455,bg=#333644,nobold,nounderscore,noitalics]"
      '';
      plugins = with pkgs; [
        tmuxPlugins.gruvbox
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
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
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
      ];
    };

    home.shellAliases = {
      mx = "tmux";
    };
  };
}
