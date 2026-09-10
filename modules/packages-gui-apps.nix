# Packages - GUI and Desktop apps.
{
  pkgs,
  unstablePkgs,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    audacity
    baobab
    blobdrop
    ddcui
    ddcutil
    ffmpeg_7-full
    flameshot
    foliate
    ghostty
    gimp-with-plugins
    git-credential-keepassxc
    google-chrome
    gparted
    gpu-viewer
    gpxsee
    gqrx
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-rtsp-server
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    imhex
    inkscape
    insync
    insync-nautilus
    intel-gpu-tools
    iosevka
    unstablePkgs.joplin-desktop # Error: In order to synchronise, please upgrade your application to version 3.7.0+. TODO: Revert to stable.
    keepassxc
    libheif
    libreoffice
    libva-utils # For vainfo (video accel)
    linssid
    losslesscut-bin
    mediainfo-gui
    mesa-demos
    powerline-fonts
    qgis
    signal-desktop
    solaar
    telegram-desktop
    transmission_4
    transmission_4-gtk
    v4l-utils
    vlc
    vscodium
    webcamoid
    wireshark
    xournalpp
  ];

  # Evolution with exchange connector
  programs.evolution = {
    enable = true;
    plugins = [pkgs.evolution-ews];
  };

  nixpkgs.overlays = [
    (import ../overlays/evolution-no-spam.nix)
  ];
}
