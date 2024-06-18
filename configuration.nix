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

  boot.initrd.luks.devices."luks-aad5ea7d-9f2e-470f-8642-d269998e034c".device = "/dev/disk/by-uuid/aad5ea7d-9f2e-470f-8642-d269998e034c";
  networking.hostName = "nixbox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # DDC
  hardware.i2c.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  # Exclude some Gnome packages
  # https://nixos.wiki/wiki/GNOME#Excluding_some_GNOME_applications_from_the_default_install
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      gnome-music
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "i2c"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
  environment.systemPackages = with pkgs; [
    bat
    bc
    btop
    chezmoi
    curl
    ddcui
    ethtool
    fzf
    git
    htop
    iftop
    imagemagick
    iperf
    jq
    minicom
    moreutils
    mycli
    nettools
    nmap
    openvpn
    pbzip2
    pdftk
    pgcli
    poppler_utils
    potrace
    powertop
    pv
    python3
    ripgrep
    screen
    sqlite
    sysstat
    tmux
    unrar
    wget
    whois
    zstd

    # Backup
    libsecret
    borgbackup

    # Fish
    fishPlugins.z

    # Desktop apps
    baobab
    ddcutil
    ffmpeg_7-full
    flameshot
    gimp-with-plugins
    gnome.gnome-tweaks
    gnome.sushi
    google-chrome
    inkscape
    insync
    insync-nautilus
    iosevka
    joplin-desktop
    keepassxc
    libreoffice
    mediainfo-gui
    powerline-fonts
    solaar
    sublime-merge-dev
    telegram-desktop
    vlc
    vscodium

    # Dev
    clang-tools
    gcc9
    gnumake
    go
    rustc
    cargo

    # Gnome extensions
    gnomeExtensions.appindicator # App tray
    gnomeExtensions.ddterm # Drop down terminal
    gnomeExtensions.dash-to-dock # Dock
    gnomeExtensions.move-clock
    gnomeExtensions.brightness-panel-menu-indicator
    gnomeExtensions.solaar-extension
  ];

  # For Gnome app indicators
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # For Solaar
  hardware.logitech.wireless.enable = true;

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
