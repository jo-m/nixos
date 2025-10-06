# Printing and scanning.
{
  config,
  pkgs,
  unstablePkgs,
  username,
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

  users.users."${username}".extraGroups = ["lp" "scanner"];
}
