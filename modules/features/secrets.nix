{ self, inputs, ... }: {
  flake.nixosModules.secrets = { config, ... }: {
    sops = {
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.keyFile = "/var/lib/sops-nix/key.txt";
      age.generateKey = true;
    };
  };

  flake.homeModules.secrets = { config, ... }: {
    sops = {
      defaultSopsFile = ../../secrets/home.yaml;
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
}
