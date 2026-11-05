# Packages - GUI and Desktop apps.
{
  pkgs,
  unstablePkgs,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    asunder # CDs
    audacity
    baobab
    ddcui
    ddcutil
    ffmpeg-full
    flameshot
    foliate
    gimp-with-plugins
    git-credential-keepassxc
    google-chrome
    gparted
    gpu-viewer
    gpxsee
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
    keepassxc
    lame # CDs
    libheif
    libreoffice
    libva-utils # For vainfo (video accel)
    linssid
    losslesscut-bin
    powerline-fonts
    signal-desktop
    solaar
    transmission_4
    transmission_4-gtk
    unstablePkgs.joplin-desktop # Error: In order to synchronise, please upgrade your application to version 3.7.0+. TODO: Revert to stable.
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
}
