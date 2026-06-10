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
    fzf-make
    gcc13
    gdb
    git-lfs
    gitFull
    gitui
    gnumake
    gperf
    hugo
    icdiff
    lazygit
    meld
    nodejs_22
    numbat
    pgcli
    pkg-config
    pngcrush
    ruff
    rustc
    sqlite-interactive
    sqlitebrowser
    sublime-merge
    svgo
    pkgs.go_1_26 # We always want the newest Go

    # Hardware
    tio

    unstablePkgs.claude-code
  ];
}
