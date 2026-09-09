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
        };
      };
    };
}
