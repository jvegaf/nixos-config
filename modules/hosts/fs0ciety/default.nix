{ self, inputs, ... }: {
  flake.nixosConfigurations.fs0ciety = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.fs0ciety
      self.nixosModules.fs0ciety-configuration
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
