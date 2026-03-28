# JAI - ultra lightweight jail for AI CLIs.
# https://github.com/stanford-scs/jai
# Requires setuid root (uses CLONE_NEWNS).
{pkgs, ...}: {
  nixpkgs.overlays = [
    (import ../overlays/jai.nix)
  ];

  security.wrappers.jai = {
    source = "${pkgs.jai}/bin/jai";
    owner = "root";
    group = "root";
    setuid = true;
  };
}
