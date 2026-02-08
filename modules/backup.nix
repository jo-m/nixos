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
  borgPrintRepoKey = pkgs.writeShellApplication {
    name = "borg-print-repo-key";

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
  borgRsh = pkgs.writeShellApplication {
    name = "borg-rsh";

    runtimeInputs = with pkgs; [
      coreutils
      openssh
    ];

    text = ''
      uid="$(id -u ${config.custom.unprivilegedUser})"

      # https://wiki.gnome.org/Projects/GnomeKeyring/Ssh
      SSH_AUTH_SOCK="/run/user/$uid/gcr/ssh"
      export SSH_AUTH_SOCK

      sudo -u ${config.custom.unprivilegedUser} --preserve-env=SSH_AUTH_SOCK ssh "$@"
    '';
  };
in {
  # Export this for the backup scripts.
  environment.systemPackages = [
    borgPrintRepoKey
    borgRsh
  ];
}
