{
  flake.wrappers.zsh =
    {
      wlib,
      config,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.zsh ];

      config = {
        zshAliases = {
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
          freb = "sudo nixos-rebuild switch --flake ~/nixdots#razer-blade";
          frem = "sudo nixos-rebuild switch --flake ~/nixdots#fs0ciety";
          jup = "just up";
          jde = "just deploy";
          r = "ranger";
          v = "nvim";
          se = "sudoedit";
          y = "yazi";
          b = "bat";
          rmd = "rm -rf";
          dots = "cd ~/nixconf";
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
          # edalias = "nvim ~/nixdots/home-manager/modules/zsh.nix";

          gb = "nix-collect-garbage -d";
          clean = "nh clean all --keep 3";

          g = "lazygit";
          gs = "git status";
          ga = "git add";
          gaa = "git add .";
          gc = "git commit";
          gps = "git push";
          gpl = "git pull --rebase --autostash";
          gco = "git checkout";
          gcl = "git clone";

          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
        };

      };
    };
}
