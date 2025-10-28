# Packages - Dev tools.
{
  config,
  pkgs,
  unstablePkgs,
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
    unstablePkgs.go_1_25 # We always want the newest Go
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
  ];
}
