{
  flake.modules.nixvim.base.plugins = {

    diffview = {
      enable = true;
      settings = {
        enhanced_diff_hl = true;
      };
    };
    fidget.enable = true;
    lastplace.enable = true;
    grug-far.enable = true;
    luasnip.enable = true;
    markview.enable = true;
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
      };
    };
    tmux-navigator.enable = true;
    lazygit.enable = true;
    nvim-ufo.enable = true;
    smear-cursor.enable = true;
  };
}
