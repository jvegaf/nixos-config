{
  flake.modules.nixvim.base.plugins = {
    web-devicons.enable = true;

    mini = {
      enable = true;
      modules = {
        comment = { };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };
  };
}
