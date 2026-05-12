# JAI - ultra lightweight jail for AI CLIs.
# https://github.com/stanford-scs/jai
# Requires setuid root (uses CLONE_NEWNS) plus a dedicated unprivileged
# "untrusted" user that strict-mode sandboxes drop privileges to.
{pkgs, ...}: {
  nixpkgs.overlays = [
    (import ../overlays/jai.nix)
  ];

  # Setuid wrapper - jai needs CAP_SYS_ADMIN to create mount namespaces.
  security.wrappers.jai = {
    source = "${pkgs.jai}/bin/jai";
    owner = "root";
    group = "root";
    setuid = true;
  };

  # Dedicated unprivileged user that strict-mode jails run as.
  # jai matches this user by name (compiled in), and additionally
  # checks the GECOS field equals "JAI sandbox untrusted user" and
  # the home directory equals "/" - see jai.cc:117 in upstream.
  users.users.jai = {
    isSystemUser = true;
    group = "jai";
    description = "JAI sandbox untrusted user";
    home = "/";
    createHome = false;
    shell = "/run/current-system/sw/bin/nologin";
  };
  users.groups.jai = {};
}
