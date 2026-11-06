{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings.binds = {
      # Focus Columns
      "Mod+Left".focus-column-left = [ ];
      "Mod+Right".focus-column-right = [ ];
      "Mod+Down".focus-window-down = [ ];
      "Mod+Up".focus-window-up = [ ];
      "Mod+Ctrl+Left".focus-monitor-left = [ ];
      "Mod+Ctrl+Right".focus-monitor-right = [ ];
      "Mod+Home".focus-column-first = [ ];
      "Mod+End".focus-column-last = [ ];

      # Move Columns
      "Mod+C".center-column = [ ];
      "Mod+Ctrl+C".center-visible-columns = [ ];
      "Mod+Shift+Left".move-column-left = [ ];
      "Mod+Shift+Right".move-column-right = [ ];
      "Mod+Shift+Down".move-window-down = [ ];
      "Mod+Shift+Up".move-window-up = [ ];
      "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = [ ];
      "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = [ ];
      "Mod+Ctrl+Home".move-column-to-first = [ ];
      "Mod+Ctrl+End".move-column-to-last = [ ];

      # Resize Columns
      "Mod+F".maximize-column = [ ];
      "Mod+M".maximize-window-to-edges = [ ];
      "Mod+Shift+F".fullscreen-window = [ ];
      "Mod+Ctrl+Shift+F".toggle-windowed-fullscreen = [ ];
      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";
      "Mod+Shift+Minus".set-window-height = "-10%";
      "Mod+Shift+Equal".set-window-height = "+10%";
      "Mod+R".switch-preset-column-width = [ ];
      "Mod+Shift+R".switch-preset-column-width-back = [ ];
      "Mod+Ctrl+Shift+R".switch-preset-window-height = [ ];

      # Expel/Consume Columns
      "Mod+V".toggle-window-floating = [ ];
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = [ ];
      "Mod+BracketLeft".consume-or-expel-window-left = [ ];
      "Mod+BracketRight".consume-or-expel-window-right = [ ];

      # HJKLUI Binds
      "Mod+H".focus-column-left = [ ];
      "Mod+L".focus-column-right = [ ];
      "Mod+K".focus-window-down = [ ];
      "Mod+J".focus-window-up = [ ];
      "Mod+Ctrl+H".move-column-left = [ ];
      "Mod+Ctrl+L".move-column-right = [ ];
      "Mod+Ctrl+K".move-window-down = [ ];
      "Mod+Ctrl+J".move-window-up = [ ];
      "Mod+U".focus-workspace-down = [ ];
      "Mod+I".focus-workspace-up = [ ];
      "Mod+Shift+U".move-workspace-down = [ ];
      "Mod+Shift+I".move-workspace-up = [ ];
      "Mod+Ctrl+U".move-column-to-workspace-down = [ ];
      "Mod+Ctrl+I".move-column-to-workspace-up = [ ];
    };
  };
}
