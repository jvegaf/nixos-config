{
  flake.nixosModules.ly = { pkgs, ... }: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        bigclock = "en";
        vi_mode = true;
        vi_default_mode = "insert";
        blank_box = true;
        hide_key_hints = false;
        load = true;
        save = true;
        clear_password = false;
      };
    };
  };
}
