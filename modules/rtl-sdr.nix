# RTL-SDR user access.
{
  config,
  pkgs,
  unstablePkgs,
  hostname,
  username,
  ...
}: {
  # Driver setup.
  boot.blacklistedKernelModules = ["dvb_usb_rtl28xxu"];
  services.udev.packages = [pkgs.rtl-sdr];

  # User access.
  users.groups.plugdev = {};
  users.users."${username}".extraGroups = ["plugdev"];
}
