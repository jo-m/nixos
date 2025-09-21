{
  config,
  pkgs,
  ...
}: let
  username = "joni";
  hostname = "nixbox";
  unstablePkgs = pkgs.unstable;
in {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.overlays = [
    (import ./overlays/gnome-ext-system-monitor.nix)
    (import ./overlays/flameshot.nix)
  ];

  imports = [
    # Include the results of the hardware scan (`nixos-generate-config`).
    ./hardware-configuration.nix

    # User modules.
    ./modules/kernel-boot.nix
    ./modules/hardware.nix
    ./modules/system.nix
    ./modules/monitoring.nix
    ./modules/user.nix
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

    # Extra args passed to the modules.
    {
      _module.args = {inherit unstablePkgs username hostname;};
    }
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
