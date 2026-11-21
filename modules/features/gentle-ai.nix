{ inputs, ... }: {
  flake.homeModules.gentle-ai = { lib, config, ... }: {
    imports = [ inputs.gentle-ai-nix.homeManagerModules.default ];

    options.custom.gentle-ai.enable = lib.mkEnableOption "Gentle AI";

    config = lib.mkIf config.custom.gentle-ai.enable {

      programs.gentle-ai = {
        enable = true;

        providers = {
          pi = {
            enable = true;
            launcher.enable = true;
            release = "stable";
          };
        };

        components = {
          skills.enable = true;
          persona.enable = true;
          permissions.enable = true;
          sdd.enable = false;
          engram.enable = true;
        };

        communityTools.codegraph.enable = true;

        persona = "Gentleman";
        # sdd.mode = "single";
      };
    };
  };
}
