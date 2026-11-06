{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings.output = [
      # Main Monitor
      {
        _args = [ "Sharp Corporation LQ156T1JW03 Unknown" ];
        mode = "2560x1440@60";
        scale = 1.25;
      }

      # VM Testing Monitor
      {
        _args = [ "Virtual-1" ];
        mode = "1920x1080";
        scale = 1.0;
      }
    ];
  };
}
