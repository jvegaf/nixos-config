{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {

    wayland.windowManager.niri.settings.input = {
      # Keyboard
      keyboard.xkb.layout = "us";

      # Mouse
      mouse = {
        accel-speed = -0.8;
      };
      focus-follows-mouse = {
        _props.max-scroll-amount = "0%";
      };

      # Touchpad
      touchpad = {
        click-method = "button-areas";
        dwt = [ ];
        natural-scroll = [ ];
        tap = [ ];
      };

      # Trackpoint
      trackpoint = {
        natural-scroll = [ ];
      };

      # Tablet
      tablet = {
        map-to-output = "DP-1";
      };
    };
  };
}
