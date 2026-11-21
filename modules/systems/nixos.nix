{ self, ... }: {
  flake.nixosModules.nixos = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.packages
      self.nixosModules.security
      self.nixosModules.services
      self.nixosModules.nh
      self.nixosModules.locale
      self.nixosModules.networking
    ];
  };
}
