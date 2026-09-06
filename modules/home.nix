{ self, inputs, ... }: {
  flake.nixosModules.home = { pkgs, ... }: {
    imports = [
      self.nixosModules.user-thg
      self.nixosModules.onepassword
    ];

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

  flake.darwinModules.home = { pkgs, ... }: {
    imports = [ self.darwinModules.user-thg ];

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
