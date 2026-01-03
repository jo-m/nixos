# Packages - GUI and Desktop apps.
{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    audacity
    baobab
    blobdrop
    ddcui
    ddcutil
    ffmpeg_7-full
    flameshot
    foliate
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
    keepassxc
    libreoffice
    libva-utils # For vainfo (video accel)
    linssid
    losslesscut-bin
    mediainfo-gui
    mesa-demos
    pkgs.libheif
    pkgs.libheif.out
    powerline-fonts
    #qgis
    signal-desktop
    solaar
    telegram-desktop
    transmission_4
    transmission_4-gtk
    joplin-desktop
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
