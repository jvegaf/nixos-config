{ self, inputs, ... }: {
  flake.homeModules.nix-search-tv = { pkgs, config, lib, ... }: {
    home.packages = with pkgs; [
      (writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
      })
    ];
  };
}
