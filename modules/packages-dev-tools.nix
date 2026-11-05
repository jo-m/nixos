# Packages - Dev tools.
{
  pkgs,
  unstablePkgs,
  ...
}: {
  # https://fzakaria.com/2025/02/26/nix-pragmatism-nix-ld-and-envfs
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };
  services = {
    envfs = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    android-tools
    ansible
    apktool
    binwalk
    clang-tools
    cmake
    difftastic
    dive
    fzf-make
    git-lfs
    gitFull
    gnumake
    hugo
    icdiff
    meld
    nodejs
    pgcli
    pkg-config
    pkgs.go_1_27 # Newest Go.
    pngcrush
    ruff
    rustc
    sqlite-interactive
    sqlitebrowser
    sublime-merge
    svgo
    tio # Serial term.
    unstablePkgs.claude-code # Always the newest.
  ];
}
