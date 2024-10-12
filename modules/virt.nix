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
}
