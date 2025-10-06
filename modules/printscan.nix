# Printing and scanning.
{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Scanning
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
    };
  };

  users.users.${config.custom.unprivilegedUser}.extraGroups = ["lp" "scanner"];
}
