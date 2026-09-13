{ self, inputs, ... }: {
  flake.nixosModules.agents = { pkgs, lib, ... }: {
environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode
    pi
    claude-plugins
    skills
    skills-installer
    plannotator
    workmux
    # ... other tools
  ];
  };
}
