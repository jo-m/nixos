# Packages - Gnome apps and extensions.
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnome.simple-scan
    gnome.sushi
    gnomeExtensions.appindicator # App tray
    gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
    gnomeExtensions.dash-to-dock # Dock
    gnomeExtensions.ddterm # Drop down terminal
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.logo-menu
    gnomeExtensions.move-clock
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.user-themes
    papirus-icon-theme

    # VPN
    gnome.networkmanager-openconnect
    networkmanager-openconnect
  ];
}
