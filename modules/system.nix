# Various system level config.
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Enable networking
  networking.networkmanager.enable = true;

  # Stop spamming dmesg wit this.
  networking.firewall.logRefusedConnections = false;

  # Enable firmware updates.
  # Asus does not offer updates through LVFS, but we might still be able to update stuff like SSD, Logitech receiver etc.
  services.fwupd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalization properties.
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

  # Use chrony instead of timesyncd.
  # See https://chrony-project.org/faq.html.
  services.timesyncd.enable = false;
  services.chrony.enable = true;
  # Work around https://github.com/NixOS/nixpkgs/issues/445035.
  systemd.tmpfiles.rules = lib.mkAfter [
    "z ${config.services.chrony.directory}/chrony.keys 0640 root chrony - -"
  ];

  # https://www.openwall.com/lists/oss-security/2025/12/28/4
  systemd.generators.systemd-ssh-generator = "/dev/null";
  systemd.sockets.sshd-unix-local.enable = lib.mkForce false;
  systemd.sockets.sshd-vsock.enable = lib.mkForce false;

  # Disable the default NixOS shell aliases
  environment.shellAliases = {
    l = "ls -luh";
    ls = null;
    ll = null;
  };

  # Disable command-not-found, which is broken atm when using NixOS with Flakes
  # https://discourse.nixos.org/t/command-not-found-not-working/24023/5
  programs.command-not-found.enable = false;

  # Compact database from time to time.
  systemd.services.nix-daemon.serviceConfig = {
    ExecStartPre = "-${lib.getBin pkgs.sqlite}/bin/sqlite3 /nix/var/nix/db/db.sqlite VACUUM";
    # Default 90s may not be enough.
    TimeoutStartSec = "infinity";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
      persistent = false;
    };

    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };

  # Copied and adapted from https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/misc/angrr.nix.
  # TODO: As soon as we upgrade to next NixOS and get angrr >= 0.2.4,
  #       we can go back to using the simple "period" setting, see
  #       https://github.com/linyinfeng/angrr/releases/tag/v0.2.4.
  services.angrr = {
    enable = true;
    settings = {
      profile-policies = {
        system = {
          keep-booted-system = true;
          keep-current-system = true;
          keep-latest-n = 5;
          keep-since = "2months";
          profile-paths = [
            "/nix/var/nix/profiles/system"
          ];
        };
        user = {
          enable = false;
          keep-booted-system = false;
          keep-current-system = false;
          keep-latest-n = 1;
          keep-since = "14d";
          profile-paths = [
            "~/.local/state/nix/profiles/profile"
            "/nix/var/nix/profiles/per-user/root/profile"
          ];
        };
      };
      temporary-root-policies = {
        direnv = {
          path-regex = "/\\.direnv/";
          period = "2months";
        };
        result = {
          path-regex = "/result[^/]*$";
          period = "14d";
        };
      };
    };
  };
}
