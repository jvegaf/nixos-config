{
  flake.nixosModules.packages = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      age
      sops
      ssh-to-age
      nix-output-monitor
      inxi
      lshw
      just
      treefmt
    ];
  };
}
