{ self, inputs, ... }: {
  flake.nixosModules.onepassword = { pkgs, lib, ... }: {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "th3g3ntl3man" ];
    };

    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          firefox
          chromium
        '';
        mode = "0755";
      };
    };
  };

  flake.homeModules.onepassword =
    { pkgs, lib, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      systemd.user.services.onepassword = {
        Unit.Description = "1Password";
        Unit.After = [ "graphical-session.target" ];
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
          Restart = "on-failure";
        };
      };
    };
}
