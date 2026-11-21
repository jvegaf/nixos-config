{ self, ... }: {
  flake.nixosModules.server = { pkgs, lib, ... }: {

    imports = [
      self.nixosModules.nixos
    ];

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        # KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "th3g3ntl3man" ];
        MaxAuthTries = 3;
        # PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };
  };
}
