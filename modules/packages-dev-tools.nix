# Packages - Dev tools.
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    aflplusplus
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
    gcc13
    gdb
    git-lfs
    gnumake
    go
    gperf
    hugo
    icdiff
    meld
    mitmproxy
    mycli
    ncurses5
    ninja
    nodejs_20
    numbat
    pgcli
    php
    pkg-config
    pkgsCross.aarch64-multiplatform.buildPackages.gcc # Provides aarch64-unknown-linux-gnu-gcc
    pngcrush
    ruff
    rustc
    sqlite-interactive
    sublime-merge-dev
    valgrind
    yarn

    # Vulkan stuff
    glslang
    vulkan-tools
    vulkan-tools-lunarg
  ];
}
