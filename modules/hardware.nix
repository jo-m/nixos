# Various hardware config.
{
  config,
  pkgs,
  ...
}: {
  # Intel video accel drivers
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

  # DDC
  hardware.i2c.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];
  users.users.${config.custom.unprivilegedUser}.extraGroups = ["i2c"];

  # Enable flashing of QMK keyboards for non-root.
  hardware.keyboard.qmk.enable = true;
}
