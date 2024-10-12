# Generic boot and kernel options.
{
  config,
  pkgs,
  ...
}: {
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "mitigations=off"
    # Maybe later: "zswap.enabled=1"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Enable memtest
  boot.loader.systemd-boot.memtest86.enable = true;

  boot.initrd.luks.devices."luks-aad5ea7d-9f2e-470f-8642-d269998e034c".device = "/dev/disk/by-uuid/aad5ea7d-9f2e-470f-8642-d269998e034c";
}
