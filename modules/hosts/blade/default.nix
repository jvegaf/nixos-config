{ self, inputs, ... }: {
  flake.nixosConfigurations.blade = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.blade-configuration
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
