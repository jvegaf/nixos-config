{
  flake.wrappers.opencode =
    {
      wlib,
      config,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.opencode ];

      config = {
        settings = {
          "$schema" = "https://opencode.ai/config.json";
          plugin = [
            # Dynamic context pruning
            "@tarquinen/opencode-dcp@latest"
            # Support background shell commands
            "opencode-pty"
            "@plannotator/opencode@latest"
            "@mohak34/opencode-notifier@latest"
            "@tarquinen/opencode-smart-title"
            # "oh-my-opencode@latest"
            "@simonwjackson/opencode-direnv@latest"
          ];
        };
      };
    };
}
