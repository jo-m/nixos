# RTL-SDR setup and packages.
{
  config,
  pkgs,
  unstablePkgs,
  username,
  ...
}: {
  # Driver setup.
  boot.blacklistedKernelModules = ["dvb_usb_rtl28xxu"];
  services.udev.packages = [pkgs.rtl-sdr];

  # User access.
  users.groups.plugdev = {};
  users.users."${username}".extraGroups = ["plugdev"];

  # Packages
  environment.systemPackages = with pkgs; [
    dump1090
    gqrx
    multimon-ng
    rtl_433
    rtl-sdr
  ];
}
