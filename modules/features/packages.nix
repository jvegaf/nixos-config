{ self, inputs, ... }: {
  flake.homeModules.packages = { pkgs, lib, ... }: {
    home.packages =
      with pkgs;
      [
        bandwhich
        btop
        claude-code
        csvlens
        curlie
        doggo
        fastfetch
        fd
        fx
        gh
        gnupg
        grex
        htop
        httpie
        hut
        hwatch
        hyperfine
        ijq
        jq
        lazygit
        less
        lnav
        mpv
        pastel
        pgcli
        portal
        prettyping
        procs
        pv
        ripgrep
        rsync
        syncthing
        tree
        unzip
        yank
        yt-dlp
        zathura
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        firefox
        xdg-user-dirs
      ];
  };
}
