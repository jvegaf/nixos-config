{ self, inputs, ... }: {
  flake.nixosModules.home = { pkgs, ... }: {
    imports = [
      self.nixosModules.user-thg
      self.nixosModules.onepassword
    ];

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.th3g3ntl3man = { ... }: {
        imports = builtins.attrValues (self.homeModules or { }) ++ [
          inputs.sops-nix.homeManagerModules.sops
        ];
        home.stateVersion = "25.05";
      };
    };
  };
}
