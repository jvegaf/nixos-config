{ self, inputs, ... }: {
  flake.nixosModules.user-thg = { pkgs, ... }: {
    users.users.th3g3ntl3man = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
      ];
      shell = pkgs.zsh;
    };
  };

  flake.darwinModules.user-thg = { pkgs, ... }: {
    users.users.th3g3ntl3man = {
      shell = pkgs.zsh;
      home = "/Users/th3g3ntl3man";
    };
  };
}
