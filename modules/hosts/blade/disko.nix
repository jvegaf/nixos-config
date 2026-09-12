{ ... }:
let
  diskoGpt = import ../../../lib/disko-gpt.nix;
in
{
  flake.diskoConfigurations.blade = diskoGpt {
    device = "/dev/disk/by-id/nvme-CT500P1SSD8_2004E284F1D7";
    swapSize = "16G";
  };
}
