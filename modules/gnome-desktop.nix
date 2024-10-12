# Wayland/X11 and Gnome setup.
{
  config,
  pkgs,
  unstablePkgs,
  hostname,
  username,
  ...
}: {
  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  # Workaround to make Gnome HEIF thumbnails work
  environment.pathsToLink = ["share/thumbnailers"];

  # For Gnome app indicators
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # For Solaar
  hardware.logitech.wireless.enable = true;
}
