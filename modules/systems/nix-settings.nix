{ inputs, ... }: {
  # Shared nix daemon settings applied by host configurations
  # Both NixOS and darwin hosts import relevant settings from here
  imports = [ inputs.flake-parts.flakeModules.touchup ];

  # Remove it
  touchup.attr.formatter.enable = false;
}
