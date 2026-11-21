{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings.binds = {
      "Mod+D".spawn = [
        "dms"
        "ipc"
        "call"
        "spotlight"
        "toggle"
      ];
      "Mod+Shift+B".spawn = [
        "dms"
        "ipc"
        "call"
        "wallpaperCarousel"
        "toggle"
      ];
      "Mod+C".spawn = [
        "dms"
        "ipc"
        "call"
        "settings"
        "focusOrToggle"
      ];
      "Mod+Alt+L".spawn = [
        "dms"
        "ipc"
        "call"
        "lock"
        "lock"
      ];
      "Mod+Shift+E".spawn = [
        "dms"
        "ipc"
        "call"
        "processlist"
        "focusOrToggle"
      ];
    };
  };
}
