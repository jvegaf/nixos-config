{ self, inputs, ... }: {
  flake.homeModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;

      ignores = [
        ".direnv"
        "result"
        "node_modules"
      ];

      settings = {
        extraConfig = {
          init = {
            defaultBranch = "main";
          };

          core.editor = "nvim";
          pull.rebase = true;

          diff.colorMoved = "default";
          # commit.gpgSign = true;
          # gpg.format = "ssh";
          # user.signingkey = "${config.home.homeDirectory}/.ssh/gitkey";

          # push = {
          #   default = "current";
          #   followTags = true;
          #   autoSetupRemote = true;
          # };
          # signing = {
          #   signByDefault = true;
          #   key = "${config.home.homeDirectory}/.ssh/gitkey";
          # };
        };

        user = {
          email = "josevega234@gmail.com";
          name = "Jose Vega";
        };
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    home.shellAliases = {
      gs = "git status";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit";
      gps = "git push";
      gpl = "git pull --rebase --autostash";
      gco = "git checkout";
      gcl = "git clone";
    };
  };
}
