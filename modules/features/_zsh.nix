{ config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases =
      let
        mngClients = ''
          mmsg get all-clients | jq -r '
            ["ID", "APP_ID", "TAG", "FLOAT", "FOCUS", "TITULO"],
            ["--", "------", "---", "-----", "-----", "------"],
            (.clients[] | [
              .id,
              .appid,
              (.tags | join(",")),
              .is_floating,
              .is_focused,
              .title
            ]) | @tsv' | column -ts $'\t'
        '';
      in
      {
        sw = "nh os switch";
        upd = "nh os switch --update";
        hms = "nh home switch";

        env-ini = "devenv init --include-envrc";
        ls = "eza -lh --group-directories-first --icons=auto";
        l = "ls";
        ll = "ls -a";
        lt = "eza --tree --level=2 --long --icons --git";
        llt = "lt -a";
        rebuild = "sudo nixos-rebuild switch";
        jup = "just up";
        jde = "just deploy";
        r = "ranger";
        v = "nvim";
        se = "sudoedit";
        y = "yazi";
        b = "bat";
        rmd = "rm -rf";
        dots = "cd ~/nixdots";
        doc = "cd ~/Documents";
        dw = "cd ~/Downloads";
        dt = "cd ~/Desktop";
        cdc = "cd ~/Code";
        mx = "tmux";
        grep = "grep --color=auto";
        "v." = "(nvim $PWD &>/dev/null &)";
        "o." = "($FILE_MANAGER $PWD &>/dev/null &)";
        ffe = "fastfetch";
        bt = "btop";
        jctl = "journalctl -p 3 -xb";
        lzd = "lazydocker";
        edalias = "nvim ~/nixdots/modules/home/shell/zsh.nix";

        gb = "nix-collect-garbage -d";
        clean = "nh clean all --keep 3";

        g = "lazygit";
        mncl = mngClients;

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent = ''
      function gcls() {
        git clone "git@github.com:jvegaf/$1.git"
      }
      # Start Tmux automatically if not already running. No Tmux in TTY
      # if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
      #   tmux attach-session -t default || tmux new-session -s default
      # fi
      export PATH="$PATH:/home/th3g3ntl3man/.local/bin"
      fastfetch

      # Start UWSM
      # if uwsm check may-start > /dev/null && uwsm select; then
      #   exec systemd-cat -t uwsm_start uwsm start default
      # fi
    '';
  };
}
