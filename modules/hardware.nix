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

  # Intel NPU/VPU firmware
  hardware.firmware = [
    (
      let
        model = "37xx";
        version = "v1.5.1";
        fw-version = "v0.0";

        firmware = pkgs.fetchurl {
          url = "https://github.com/intel/linux-npu-driver/raw/${version}/firmware/bin/vpu_${model}_${fw-version}.bin";
          hash = "sha256-KVO9EF/faYV1g2st59fIgEHqCYIgM+JhSSfzOlcA7SU=";
        };
      in
        pkgs.runCommand "intel-vpu-firmware-${model}-${fw-version}" {} ''
          mkdir -p "$out/lib/firmware/intel/vpu"
          cp '${firmware}' "$out/lib/firmware/intel/vpu/vpu_${model}_${fw-version}.bin"
        ''
    )
  ];

  # DDC
  hardware.i2c.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];
  users.users.${config.custom.unprivilegedUser}.extraGroups = ["i2c"];

  # Enable flashing of QMK keyboards for non-root.
  hardware.keyboard.qmk.enable = true;
}
