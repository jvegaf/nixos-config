{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings.binds = {
      "Mod+D".spawn-sh = "noctalia msg panel-toggle launcher";
      "Mod+Shift+B".spawn-sh = "noctalia msg panel-toggle wallpaper";
      "Mod+Comma".spawn-sh = "noctalia msg panel-toggle control-center";
      "Mod+Alt+L".spawn-sh = "noctalia msg session lock";
      "Mod+Pause".spawn-sh = "noctalia msg notification-dnd-toggle";
      "Pause".spawn-sh = "noctalia msg mic-mute";
      "Print".spawn-sh = "noctalia msg screenshot-region";
      "Mod+Print".spawn-sh = "noctalia msg screenshot-fullscreen pick";
    };
  };
}
