# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  username = "joni";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
  networking.hostName = "nixbox"; # Define your hostname.

  # Intel video accel drivers
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

  # Enable firmware updates
  services.fwupd.enable = true;

  # DDC
  hardware.i2c.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "de_CH.UTF-8/UTF-8"
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Autologin
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  security.sudo.extraRules = [
    {
      users = [username];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/Sync"; # Default folder for new synced folders
    configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  # Syncthing ports:
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  # Exclude some Gnome packages
  # https://nixos.wiki/wiki/GNOME#Excluding_some_GNOME_applications_from_the_default_install
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-console # use gnome-terminal instead
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      atomix # puzzle game
      epiphany # web browser
      geary # email reader
      gnome-music
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]);

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Scanning
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "i2c" "scanner" "lp"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Evolution with exchange connector
  programs.evolution = {
    enable = true;
    plugins = [pkgs.evolution-ews];
  };

  # Fish
  programs.fish.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    my-python3 = python3.withPackages (ps: with ps; [pip]);
    my-texlive = texlive.combine {
      inherit
        (texlive)
        scheme-full
        moderncv
        ;
    };
  in [
    # Basics
    bc
    cpuid
    curl
    file
    git
    htop
    iftop
    iperf
    iproute2
    iw
    jq
    lshw
    minicom
    moreutils
    my-python3
    neofetch
    nettools
    openvpn
    p7zip
    pbzip2
    pigz
    procps
    pv
    screen
    tmux
    unrar
    util-linux
    wget
    whois
    zstd

    # Sysadmin CLI
    bcc
    bpftrace
    bridge-utils
    dmidecode
    dnsutils
    ethtool
    f3
    hdparm
    nmap
    numactl
    powertop
    smartmontools
    sysstat
    tcpdump
    trace-cmd
    tshark
    usbutils

    # User CLI utilities
    bat
    btop
    chezmoi
    direnv
    exiftool
    fzf
    glxinfo
    graphviz
    imagemagick
    my-texlive
    qpdf # For CV
    pdftk
    poppler_utils
    potrace
    qrencode
    ripgrep
    zbar

    # Fish
    fishPlugins.z

    # Desktop/GUI apps
    audacity
    baobab
    ddcui
    ddcutil
    ffmpeg_7-full
    flameshot
    gimp-with-plugins
    google-chrome
    gparted
    gpu-viewer
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
    inkscape
    insync
    insync-nautilus
    intel-gpu-tools
    iosevka
    joplin-desktop
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
    qgis
    signal-desktop
    solaar
    telegram-desktop
    transmission
    transmission-gtk
    vlc
    vscodium
    vulkan-tools
    webcamoid
    wireshark
    xournalpp

    # Gnome apps and extensions
    gnome.dconf-editor
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnome.simple-scan
    gnome.sushi
    gnomeExtensions.appindicator # App tray
    gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
    gnomeExtensions.dash-to-dock # Dock
    gnomeExtensions.ddterm # Drop down terminal
    gnomeExtensions.logo-menu
    gnomeExtensions.move-clock
    gnomeExtensions.user-themes
    papirus-icon-theme

    # Dev tools, CLI and GUI
    aflplusplus
    android-tools
    ansible
    apktool
    avrdude
    binwalk
    bison
    cargo
    ccache
    clang-tools
    cmake
    difftastic
    dive
    flex
    gcc9
    gdb
    git-lfs
    gnumake
    go
    gperf
    hugo
    icdiff
    meld
    mitmproxy
    mycli
    ncurses5
    ninja
    nodejs_20
    pgcli
    php
    pkg-config
    pkgsCross.aarch64-multiplatform.buildPackages.gcc # Provides aarch64-unknown-linux-gnu-gcc
    pngcrush
    rustc
    sqlite
    sublime-merge-dev
    valgrind
    yarn

    # Backup
    borgbackup
    libsecret
  ];

  # Workaround to make Gnome HEIF thumbnails work
  environment.pathsToLink = ["share/thumbnailers"];

  # For Gnome app indicators
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # For Solaar
  hardware.logitech.wireless.enable = true;

  # Disable the default NixOS shell aliases
  environment.shellAliases = {
    l = "ls -luh";
    ls = null;
    ll = null;
  };

  # Rootless Docker
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Virtualbox with experimental KVM
  virtualisation.virtualbox.host = {
    enable = true;
    # https://github.com/cyberus-technology/virtualbox-kvm/
    enableKvm = true;
    addNetworkInterface = false; # Not supported with KVM
    enableHardening = false; # Not supported with KVM
  };
  users.extraGroups.vboxusers.members = [username];

  # Disable command-not-found, which is broken atm when using NixOS with Flakes
  # https://discourse.nixos.org/t/command-not-found-not-working/24023/5
  programs.command-not-found.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
