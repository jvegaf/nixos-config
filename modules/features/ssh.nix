{ self, inputs, ... }: {
  flake.homeModules.ssh = { pkgs, ... }: {

    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          IdentityFile = "~/.ssh/id_ed25519";
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
