{ self, ... }: {
  flake.nixosModules.user-thg = { pkgs, ... }: {
    programs.zsh.enable = true;

    users.users.th3g3ntl3man = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "input"
      ];
      shell = pkgs.zsh;
    };
  };
}
