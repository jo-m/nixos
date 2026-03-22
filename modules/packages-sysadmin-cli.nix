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
    nvme-cli
    powertop
    smartmontools
    sysstat
    tpm2-tools
    trace-cmd
    usbutils

    # Networking
    bridge-utils
    dnsutils
    nmap
    openconnect
    openvpn
    openvpn-auth-ldap
    openvpn3
    ssh-audit
    tcpdump
    trippy
    tshark

    # Backup
    borgbackup
    libsecret
  ];
}
