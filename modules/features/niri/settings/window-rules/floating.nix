{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings.window-rule = [
      # Terminal Scratchpad
      {
        match._props.app-id = "kitty-scratchpad";
        open-floating = true;
        default-column-width.proportion = 0.6;
        default-window-height.proportion = 0.6;

        default-floating-position._props = {
          x = 410;
          y = 222;
          relative-to = "top-left";
        };
      }

      {
        match._props.title = "Inicia sesión: Cuentas de Google — Mozilla Firefox";
        open-floating = true;
        default-column-width.proportion = 0.5;
        default-window-height.proportion = 0.5;

        default-floating-position._props = {
          x = 410;
          y = 222;
          relative-to = "top-left";
        };
      }

      {
        match._props.app-id = "com.onepassword.OnePassword";
        open-floating = true;
        default-column-width.proportion = 0.6;
        default-window-height.proportion = 0.6;

        default-floating-position._props = {
          x = 410;
          y = 222;
          relative-to = "top-left";
        };
      }

      {
        match._props.app-id = "org.gnome.Nautilus";
        open-floating = true;
        default-column-width.proportion = 0.6;
        default-window-height.proportion = 0.6;

        default-floating-position._props = {
          x = 410;
          y = 222;
          relative-to = "top-left";
        };
      }

      {
        match._props.title = "^Open$";
        open-floating = true;
        default-column-width.proportion = 0.6;
        default-window-height.proportion = 0.6;

        default-floating-position._props = {
          x = 410;
          y = 222;
          relative-to = "top-left";
        };
      }
      # Firefox PIP
      {
        match._props = {
          app-id = "firefox";
          title = "^Picture-in-Picture$";
        };

        open-floating = true;
        open-focused = false;

        default-floating-position._props = {
          x = 10;
          y = 10;
          relative-to = "bottom-right";
        };
      }

      # Gnome Calculator
      {
        match._props.app-id = "org.gnome.Calculator";

        open-floating = true;
        default-column-width.fixed = 400;
        default-window-height.fixed = 620;

        default-floating-position._props = {
          x = 10;
          y = 10;
          relative-to = "bottom-right";
        };
      }
    ];
  };
}
