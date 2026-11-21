{ self, ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    imports = [
      self.nixosModules.nixos
      self.nixosModules.fonts
      self.nixosModules.niri
      self.nixosModules.ly
      # self.nixosModules.printing
    ];

    # XDG portal for screen sharing, file dialogs, etc.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    # GNOME Keyring
    services.gnome.gnome-keyring.enable = true;
  };
}
