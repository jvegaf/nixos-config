{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    imports = [ inputs.niri-nix.nixosModules.default ];

    # Niri package overlay
    # nixpkgs.overlays = [ inputs.niri-nix.overlays.niri-nix ];
    programs.niri = {
      enable = true;
      # withUWSM = true;
      # package = pkgs.niri-unstable;
    };

    environment = {
      systemPackages = with pkgs; [
        wl-clipboard
        wlr-randr
        grim
        slurp
        brightnessctl
        playerctl
        parole
        nautilus
        sushi
        xwayland-satellite
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };

  flake.homeModules.niri = { ... }: {
    imports = [
      inputs.niri-nix.homeModules.default
    ];

    wayland.windowManager.niri.enable = true;

  };

}
