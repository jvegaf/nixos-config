{
  self,
  ...
}:
{

  flake.homeModules.tmux = { pkgs, lib, ... }: {

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      prefix = "C-a";
      keyMode = "vi";
      sensibleOnTop = true;
      terminal = "tmux-256color";
      aggressiveResize = true;
      clock24 = true;
      customPaneNavigationAndResize = true;
      focusEvents = true;
      newSession = true;
      secureSocket = false;
      tmuxp.enable = true;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.fzf-tmux-url
        tmuxPlugins.tmux-which-key
        tmuxPlugins.tmux-powerline
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.tmux-thumbs
      ];
      extraConfig = ''
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set -as terminal-overrides ",xterm*:Tc"

        set -g status-position top

        # Fix colors for various terminals
        set -as terminal-overrides ",alacritty*:Tc"
        set -as terminal-overrides ",kitty*:Tc"
        set -as terminal-overrides ",ghostty*:Tc"

        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy && wl-paste -n | wl-copy -p"
        bind-key p run "wl-paste -n | tmux load-buffer - ; tmux paste-buffer"

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

        bind c new-window -c "#{pane_current_path}"
        bind '-' split-window -c "#{pane_current_path}"
        unbind .
        bind . split-window -h -c "#{pane_current_path}"

        bind x kill-pane
        bind e kill-window
        bind -n M-Q kill-session
        set -g detach-on-destroy off  # don't exit from tmux when closing a session
      '';
    };

    home.shellAliases = {
      mx = "tmux";
    };
  };
}
