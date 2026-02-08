# Packages - basics.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; let
    myPython3 = python3.withPackages (ps: with ps; [pip]);
  in [
    bc
    cpuid
    curl
    file
    htop
    iftop
    iperf
    iproute2
    iw
    jq
    lshw
    minicom
    moreutils
    myPython3
    nettools
    p7zip
    pbzip2
    pigz
    procps
    psmisc
    pv
    screen
    tmux
    tree
    unrar
    util-linux
    wget
    whois
    zstd
  ];
}
