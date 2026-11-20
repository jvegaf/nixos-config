{ self, ... }: {
  flake.nixosModules.desktop = { ... }: {
    imports = [
      self.nixosModules.nixos
      self.nixosModules.nh
      self.nixosModules.networking
      self.nixosModules.fonts
      self.nixosModules.niri
      # self.nixosModules.agents
      # self.nixosModules.printing
    ];
  };
}
