# RTL-SDR setup and packages.
{
  config,
  pkgs,
  ...
}: {
  # Driver setup.
  boot.blacklistedKernelModules = ["dvb_usb_rtl28xxu"];
  services.udev.packages = [pkgs.rtl-sdr];

  # User access.
  users.groups.plugdev = {};
  users.users.${config.custom.unprivilegedUser}.extraGroups = ["plugdev"];

  # Packages
  environment.systemPackages = with pkgs; [
    dump1090-fa
    gqrx
    multimon-ng
    rtl_433
    rtl-sdr
  ];
}
