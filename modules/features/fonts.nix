{ self, inputs, ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      maple-mono.NF
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      open-sans
      noto-fonts
      liberation_ttf_v2
      dejavu_fonts
      cantarell-fonts
    ];
  };

  flake.darwinModules.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      maple-mono.NF
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
    ];
  };
}
