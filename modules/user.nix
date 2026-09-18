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
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 443;
  };
  # The 10.0.0.13/24 secondary address that Teddycloud needs lives on the
  # NetworkManager connection profile instead of here. NetworkManager manages
  # wlo1, so networking.interfaces.wlo1.ipv4.addresses would be applied by a
  # device-wanted oneshot (network-addresses-wlo1.service) that NetworkManager
  # can flush when it activates the connection. Configured with:
  #   nmcli con mod asdf +ipv4.addresses 10.0.0.13/24
}
