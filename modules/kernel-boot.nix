# Generic boot and kernel options.
{
  pkgs,
  lib,
  ...
}: {
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "mitigations=off"

    # Disable GuC, hoping to reduce crashes like this one:
    #  i915 0000:00:02.0: [drm] *ERROR* GT0: GUC: TLB invalidation response timed out for seqno 3748100
    #  i915 0000:00:02.0: [drm] *ERROR* GT0: GUC: TLB invalidation response timed out for seqno 3748101
    #  i915 0000:00:02.0: [drm] GPU HANG: ecode 12:0:00000000
    #  i915 0000:00:02.0: [drm] GPU error state saved to /sys/class/drm/card1/error
    #  i915 0000:00:02.0: [drm] GT0: Resetting chip for stopped heartbeat on rcs0
    # TODO: Eventually enable this again, especially if we still crash.
    "i915.enable_guc=0"
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Bootloader and secure boot.
  # https://github.com/nix-community/lanzaboote/blob/v0.4.2/docs/QUICK_START.md
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd.luks.devices."luks-aad5ea7d-9f2e-470f-8642-d269998e034c".device = "/dev/disk/by-uuid/aad5ea7d-9f2e-470f-8642-d269998e034c";
}
