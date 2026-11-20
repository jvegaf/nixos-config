{ lib, ... }: {
  options.flake = {
    homeModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = "Home-manager modules, merged across all feature files.";
    };
  };
}
