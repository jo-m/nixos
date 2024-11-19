# Various system level config.
{
  config,
  pkgs,
  hostname,
  username,
  ...
}: {
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = hostname;

  # Enable firmware updates.
  # Asus does not offer updates through LVFS, but we might still be able to update stuff like SSD, Logitech receiver etc.
  services.fwupd.enable = true;

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

    extraLocaleSettings = {
      LC_MONETARY = "de_CH.UTF-8";
      LC_TIME = "de_CH.UTF-8";
      LC_NUMERIC = "de_CH.UTF-8";
    };
  };

  # Disable the default NixOS shell aliases
  environment.shellAliases = {
    l = "ls -luh";
    ls = null;
    ll = null;
  };

  # Disable command-not-found, which is broken atm when using NixOS with Flakes
  # https://discourse.nixos.org/t/command-not-found-not-working/24023/5
  programs.command-not-found.enable = false;
}
