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
    gitFull
    gitui
    lazygit
    fzf-make
    gnumake
    unstablePkgs.go # We always want the newest Go
    gperf
    hugo
    icdiff
    meld
    mitmproxy
    mycli
    ncurses5
    ninja
    nodejs_22
    numbat
    pgcli
    php
    pkg-config
    pkgsCross.aarch64-multiplatform.buildPackages.gcc # Provides aarch64-unknown-linux-gnu-gcc
    pngcrush
    ruff
    rustc
    sqlite-interactive
    sqlitebrowser
    sublime-merge-dev
    valgrind

    # Hardware
    tio

    # Vulkan basic tools and dependencies
    glslang
    shaderc # glslc
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers

    # More Vulkan tools
    vulkan-extension-layer
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-volk

    # Intel GPU
    #level-zero
    #mkl
    #oneDNN
    #openvino
    #vpl-gpu-rt

    # Vibing
    unstablePkgs.claude-code
  ];
}
