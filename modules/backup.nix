# Backup scripts.
# See https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/backup/borgbackup.nix.
{
  config,
  pkgs,
  lib,
  unstablePkgs,
  ...
}: let
  borgRepoKeyKeepassUrl = "borg-passphrase://backup";
  printBorgRepoKey = pkgs.writeShellApplication {
    name = "printBorgRepoKey";

    runtimeInputs = with pkgs; [
      coreutils
      git-credential-keepassxc
      getent
    ];

    text = ''
      # https://github.com/Frederick888/git-credential-keepassxc/blob/master/src/utils/socket.rs
      uid="$(id -u ${config.custom.unprivilegedUser})"
      KEEPASSXC_BROWSER_SOCKET_PATH="/run/user/$uid/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer"
      export KEEPASSXC_BROWSER_SOCKET_PATH

      home="$(getent passwd ${config.custom.unprivilegedUser} | cut -d: -f6)"

      echo 'url=${borgRepoKeyKeepassUrl}' \
        | git-credential-keepassxc --config "$home/.config/git-credential-keepassxc" get \
        | sed -n 's/^password=//p'
    '';
  };
  userRsh = pkgs.writeShellApplication {
    name = "userRsh";

    runtimeInputs = with pkgs; [
      coreutils
      openssh
    ];

    text = ''
      uid="$(id -u ${config.custom.unprivilegedUser})"

      # https://wiki.gnome.org/Projects/GnomeKeyring/Ssh
      SSH_AUTH_SOCK="/run/user/$uid/keyring/ssh"
      export SSH_AUTH_SOCK

      sudo -u ${config.custom.unprivilegedUser} --preserve-env=SSH_AUTH_SOCK ssh "$@"
    '';
  };
  archiveName = "test"; # TODO
  postfix = "-${config.networking.hostName}-${archiveName}";
in {
  # Start and monitor manually:
  #   sudo systemctl start borgbackup-job-test.service
  #   journalctl -fu borgbackup-job-test.service
  services.borgbackup.jobs.test = {
    doInit = false;
    appendFailedSuffix = true; # TODO: Clean those up.
    preHook = ''
      set -x

      archiveName="$(date +%Y-%m-%d_%H-%M-%S)${postfix}"
    '';
    extraCreateArgs = "--verbose --stats";
    paths = "/boot";
    encryption.mode = "repokey";
    encryption.passCommand = lib.getExe printBorgRepoKey;
    # removableDevice=true; # TODO: Set
    environment = {
      BORG_REMOTE_PATH = "borg1";
      BORG_RSH = lib.getExe userRsh;
    };
    # `rsync.net` needs a matching entry in `~/.ssh/config`.
    repo = "rsync.net:backup.borg"; # TODO: backup.borg
    compression = "zstd";
    startAt = []; # TODO: "daily";

    exclude = []; # TODO: fill in.

    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 8;
      monthly = 12;
      yearly = -1;
    };
    prune.prefix = null;
    extraPruneArgs = "--glob-archives ${lib.escapeShellArg "*${postfix}"}";
  };
}
