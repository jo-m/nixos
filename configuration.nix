{
  config,
  pkgs,
  options,
  lib,
  ...
}: {
  options.custom.unprivilegedUser = lib.mkOption {
    type = lib.types.str;
    default = "joni";
  };

  imports = [
    # Include the results of the hardware scan (`nixos-generate-config`).
    ./hardware-configuration.nix

    # User modules.
    ./modules/kernel-boot.nix
    ./modules/hardware.nix
    ./modules/system.nix
    ./modules/monitoring.nix
    ./modules/user.nix
    ./modules/backup.nix
    ./modules/gnome-desktop.nix
    ./modules/printscan.nix
    ./modules/virt.nix
    ./modules/rtl-sdr.nix
    ./modules/packages-sysadmin-cli.nix
    ./modules/packages-basic.nix
    ./modules/packages-dev-tools.nix
    ./modules/packages-gnome-apps-extensions.nix
    ./modules/packages-sysadmin-cli.nix
    ./modules/packages-user-cli.nix
    ./modules/packages-gui-apps.nix
  ];

  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
