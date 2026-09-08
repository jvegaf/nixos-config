{
  flake.modules.nixvim.base.plugins.treesitter = {
    enable = true;

    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = true;
      };
      indent.enable = true;
      incremental_selection.enable = true;
    };
  };
}
