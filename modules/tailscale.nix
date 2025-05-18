# Setup:
#
#   sudo tailscale up
{
  config,
  pkgs,
  unstablePkgs,
  hostname,
  username,
  ...
}: {
  # Make tailscale command available.
  environment.systemPackages = [unstablePkgs.tailscale];

  # Enable service.
  services.tailscale = {
    enable = true;
    package = unstablePkgs.tailscale;
  };
}
