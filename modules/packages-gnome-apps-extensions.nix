# Packages - Gnome apps and extensions.
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-terminal
    gnome-tweaks
    simple-scan
    sushi
    gnomeExtensions.appindicator # App tray
    gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
    gnomeExtensions.dash-to-dock # Dock
    gnomeExtensions.ddterm # Drop down terminal
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.logo-menu
    gnomeExtensions.move-clock
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.system-monitor
    gnomeExtensions.user-themes
    papirus-icon-theme
  ];

  nixpkgs.overlays = [
    (import ../overlays/gnome-ext-system-monitor.nix)
  ];

  # VPN
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
    networkmanager-openvpn
  ];
}
