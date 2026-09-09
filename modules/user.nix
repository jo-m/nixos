# User setup.
{config, ...}: let
  username = config.custom.unprivilegedUser;
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "dialout"];
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

  # For Teddycloud, see ~/.local/share/dockerapps/teddycloud/docker-compose.yml.
  networking.firewall.allowedTCPPorts = [443];
  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_unprivileged_port_start" = 443;
  # };
  # networking.interfaces.wlo1.ipv4.addresses = [
  #   {
  #     address = "10.0.0.13";
  #     prefixLength = 24;
  #   }
  # ];
}
