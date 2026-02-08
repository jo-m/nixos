# Packages - Sysadmin CLI tools.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Generic
    bcc
    bpftrace
    dmidecode
    ethtool
    f3
    hdparm
    lsof
    numactl
    powertop
    smartmontools
    sysstat
    trace-cmd
    tpm2-tools
    usbutils

    # Networking
    bridge-utils
    dnsutils
    nmap
    openconnect
    openvpn
    openvpn3
    openvpn-auth-ldap
    tcpdump
    tshark
    trippy
    ssh-audit

    # Backup
    borgbackup
    libsecret
  ];
}
