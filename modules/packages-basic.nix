# Packages - basics.
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; let
    my-python3 = python3.withPackages (ps: with ps; [pip]);
  in [
    bc
    cpuid
    curl
    file
    git
    htop
    iftop
    iperf
    iproute2
    iw
    jq
    lshw
    minicom
    moreutils
    my-python3
    nettools
    p7zip
    pbzip2
    pigz
    procps
    psmisc
    pv
    screen
    tmux
    unrar
    util-linux
    wget
    whois
    zstd
  ];
}
