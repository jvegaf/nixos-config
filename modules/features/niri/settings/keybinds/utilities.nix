{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings = {
      # Screenshot
      screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png";
      binds = {
        # "Print".screenshot = [ ];
        # "Alt+Print".screenshot-window = [ ];
      };
    };
  };
}
