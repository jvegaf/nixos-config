{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings.window-rule = [
      # Cider
      {
        match._props.app-id = "org.freecad.FreeCAD";
        open-on-workspace = "media";
        open-maximized = true;
      }

      # Steam - Main Monitor
      {
        match._props.app-id = "CrealityPrint";
        open-on-workspace = "media";
        open-maximized = true;
      }

      # Thunderbird
      {
        match._props.app-id = "thunderbird";
        open-on-workspace = "work";
        open-maximized = true;
      }
    ];
  };
}
