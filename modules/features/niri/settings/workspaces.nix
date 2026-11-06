{ self, inputs, ... }: {
  flake.homeModules.niri = { ... }: {
    wayland.windowManager.niri.settings = {
      workspace = [
        {
          _args = [ "main" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "work" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "chat" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "media" ];
          open-on-output = "eDP-1";
        }
      ];
    };
  };
}
