# Setup:
#   sudo tailscale up
#
# Funnel: https://tailscale.com/kb/1223/funnel
#   sudo tailscale funnel http://localhost:2345
#
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
