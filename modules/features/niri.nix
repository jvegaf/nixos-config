{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wlr-randr
      grim
      slurp
      brightnessctl
      playerctl
    ];
  };

  perSystem =
    {
      pkgs,
      lib,
      self',
      system,
      ...
    }:
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          prefer-no-csd = true;

          input = {
            keyboard.xkb = {
              layout = "us";
              # options = "ctrl:nocaps";
            };

            touchpad = {
              tap = _: { };
              dwt = _: { };
              natural-scroll = _: { };
              click-method = "clickfinger";
              scroll-method = "two-finger";
            };
          };

          # Catppuccin Mocha colors for borders
          layout = {
            gaps = 5;
            border = {
              width = 3;
              active-color = "#cba6f7"; # mauve
              inactive-color = "#313244"; # surface0
            };
            focus-ring.off = _: { };
          };

          spawn-at-startup = [
            (lib.getExe self'.packages.noctalia)
          ];

          # Named workspaces
          workspaces = {
            "web" = null;
            "chat" = null;
            "media" = null;
            "game" = null;
            "code" = null;
          };

          binds = {
            # Terminal (Shift+Return like sway)
            # "Mod+Return".spawn = lib.getExe pkgs.wezterm;
            "Mod+Return".spawn = lib.getExe self'.packages.kitty;

            "Mod+B".spawn = "firefox";

            # Kill focused window
            "Mod+Q".close-window = _: { };

            "Mod+W".toggle-overview = _: { };

            # Launcher (noctalia)
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";

            # 1Password quick access
            "Ctrl+Shift+P".spawn-sh = "1password --quick-access --ozone-platform-hint=auto";

            # Fullscreen
            "Mod+Z".fullscreen-window = _: { };

            "Mod+Shift+H".show-hotkey-overlay =_ : { };

            # Maximize column (closest sway equivalent)
            "Mod+A".maximize-column = _: { };

            # Toggle floating
            "Mod+F".toggle-window-floating = _: { };

            # Center column
            "Mod+C".center-column = _: { };

            # Focus navigation (hjkl like sway)
            "Mod+H".focus-column-left = _: { };
            "Mod+J".focus-window-down = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+Left".focus-column-left = _: { };
            "Mod+Down".focus-window-down = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Right".focus-column-right = _: { };

            # Move windows (Shift+hjkl like sway)
            "Mod+Shift+Left".move-column-left = _: { };
            "Mod+Shift+Down".move-window-down = _: { };
            "Mod+Shift+Up".move-window-up = _: { };
            "Mod+Shift+Right".move-column-right = _: { };

            # Resize (Ctrl+hjkl)
            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            # Workspaces (same numbers as sway)
            "Mod+1".focus-workspace = "web";
            "Mod+2".focus-workspace = "chat";
            "Mod+3".focus-workspace = "media";
            "Mod+4".focus-workspace = "game";
            "Mod+0".focus-workspace = "code";

            # Move to workspace
            "Mod+Shift+1".move-column-to-workspace = "web";
            "Mod+Shift+2".move-column-to-workspace = "chat";
            "Mod+Shift+3".move-column-to-workspace = "media";
            "Mod+Shift+4".move-column-to-workspace = "game";
            "Mod+Shift+0".move-column-to-workspace = "code";

            # Scroll between columns/workspaces
            "Mod+WheelScrollDown".focus-column-right = _: { };
            "Mod+WheelScrollUp".focus-column-left = _: { };
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

            # Media keys
            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioPlay".spawn-sh = "playerctl play-pause";
            "XF86AudioNext".spawn-sh = "playerctl next";
            "XF86AudioPrev".spawn-sh = "playerctl previous";

            # Brightness
            "XF86MonBrightnessUp".spawn-sh = "brightnessctl set +5%";
            "XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5%-";

            # Screenshots (grim/slurp like sway)
            "Ctrl+Shift+4".spawn = [
              (lib.getExe (
                pkgs.writeShellApplication {
                  name = "screenshot-region";
                  runtimeInputs = [
                    pkgs.grim
                    pkgs.slurp
                  ];
                  text = ''
                    mkdir -p "$HOME/Pictures/Screenshots"
                    grim -g "$(slurp)" "$HOME/Pictures/Screenshots/$(date +'grim_%m_%d_%y-%H_%M_%S.png')"
                  '';
                }
              ))
            ];

            # Lock (noctalia)
            "Mod+Shift+Space".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call lockScreen lock";

            "CTRL+ALT+Delete".quit = { };

            "Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call settings";
          };

          # Window rules (floating apps from sway)
          window-rules = [
            {
                geometry-corner-radius = 12;
                clip-to-geometry = true;
            }
            {
              matches = [ { app-id = "1Password"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "thunar"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "pavucontrol"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "nm-connection-editor"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "org.kde.polkit-kde-authentication-agent-1"; } ];
              open-floating = true;
            }
          ];
        };
      };
    };
}
