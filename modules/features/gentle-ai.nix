{ inputs, ... }: {

  flake.homeModules.gentle-ai = { ... }: {
    imports = [ inputs.gentle-ai-nix.homeManagerModules.default ];

    programs.gentle-ai = {
      enable = true;

      providers = {
        pi = {
          enable = true;
          launcher.enable = true;
          release = "main";
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

      persona = "gentleman";
      # sdd.mode = "single";
    };
  };
}
