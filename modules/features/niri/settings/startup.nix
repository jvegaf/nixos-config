{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings = {
      hotkey-overlay.skip-at-startup = true;

      spawn-at-startup = [
        { _args = [ "noctalia" ]; }
      ];
    };
  };
}
