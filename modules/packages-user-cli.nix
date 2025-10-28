# Packages - User CLI tools.
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; let
    my-texlive = texlive.combine {
      inherit
        (texlive)
        scheme-full
        moderncv
        ;
    };
  in [
    age
    bat
    broot
    btop
    chezmoi
    direnv
    exiftool
    fzf
    #glxinfo
    graphviz
    imagemagick
    #my-texlive
    #pdftk
    #poppler_utils
    #potrace
    #qpdf # For CV
    qrencode
    ripgrep
    zbar

    # z for Fish
    fishPlugins.z
  ];

  # Fish - do not set it as login shell, but let bash
  # execute it in interactive mode.
  # See https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell.
  programs.fish.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Syncthing
  services.syncthing = let
    username = config.custom.unprivilegedUser;
  in {
    enable = true;
    user = username;
    dataDir = "/home/${username}/Sync"; # Default folder for new synced folders
    configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
  };
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
}
