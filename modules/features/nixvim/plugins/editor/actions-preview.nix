{
  flake.modules.nixvim.base = {

    keymaps = [
      {
        mode = "n";
        key = "<leader>ca";
        action.__raw = ''
          function() require("actions-preview").code_actions() end
        '';
        options.desc = "Code Actions";
      }
    ];
    plugins = {
      actions-preview = {
        enable = true;
        settings = {
          backend = [
            "snacks"
            "telescope"
          ];
        };
      };
    };
  };
}
