# Virtualization and containers.
{
  config,
  pkgs,
  unstablePkgs,
  hostname,
  username,
  ...
}: {
  # Rootless Docker and Podman
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Virtualbox with experimental KVM
  virtualisation.virtualbox.host = {
    enable = true;
    # https://github.com/cyberus-technology/virtualbox-kvm/
    enableKvm = true;
    addNetworkInterface = false; # Not supported with KVM
    enableHardening = false; # Not supported with KVM
  };
  users.extraGroups.vboxusers.members = [username];

  # Libvirtd, virsh etc.
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [libguestfs-with-appliance guestfs-tools];
  users.extraGroups.libvirtd.members = [username];
  programs.virt-manager.enable = true;
}
