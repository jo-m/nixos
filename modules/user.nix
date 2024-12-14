# User setup.
{
  config,
  pkgs,
  unstablePkgs,
  hostname,
  username,
  ...
}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "dialout"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  security.sudo.extraRules = [
    {
      users = [username];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
