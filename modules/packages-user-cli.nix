# Packages - User CLI tools.
{
  config,
  pkgs,
  username,
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
    bat
    broot
    btop
    chezmoi
    direnv
    exiftool
    fzf
    glxinfo
    graphviz
    imagemagick
    my-texlive
    pdftk
    poppler_utils
    potrace
    qpdf # For CV
    qrencode
    ripgrep
    zbar

    # Fish
    fishPlugins.z
  ];

  # Fish
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
  services.syncthing = {
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
