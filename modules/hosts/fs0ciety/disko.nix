{ ... }:
let
  diskoGpt = import ../../../lib/disko-gpt.nix;
in
{
  flake.diskoConfigurations.fs0ciety = diskoGpt {
    device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLW256HEHP-00000_S33VNX0JC31966";
    swapSize = "16G";
  };
}
