{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.kitty = { pkgs, lib, ...}: {
    home.packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
    ];
  };


  flake.wrappersModules.kitty =
    {
      config,
      lib,
      ...
    }:
    {
      options.shell = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      config = {
        args = lib.mkAfter (lib.optionals (config.shell != "") [ config.shell ]);
        settings = {
          enable_audio_bell = "no";

          font_size = 12;
          font_family = "JetBrainsMono Nerd Font";

          cursor_text_color = "background";

          allow_remote_control = "yes";
          shell_integration = "enabled";

          open_url_with_default = true;
          detect_urls = true;
          cursor_trail = 3;

          # map = [
          #   "alt+1 goto_tab 1"
          #   "alt+2 goto_tab 2"
          #   "alt+3 goto_tab 3"
          #   "alt+4 goto_tab 4"
          #   "alt+5 goto_tab 5"
          #   "alt+6 goto_tab 6"
          #   "alt+7 goto_tab 7"
          #   "alt+8 goto_tab 8"
          #   "alt+9 goto_tab 9"
          #   "ctrl+shift+w close_tab"
          #   "ctrl+t new_tab_with_cwd"
          #   "ctrl+shift+t new_tab"
          # ];

          background = "#1e1e2e";
          foreground = "#cdd6f4";

          cursor = "#f5e0dc";

          selection_foreground = "#1e1e2e";
          selection_background = "#f5e0dc";

        };
      };
    };

  perSystem = { pkgs, ... }: {
    packages.kitty =
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [ self.wrappersModules.kitty ];
      }).wrapper;
  };
}
