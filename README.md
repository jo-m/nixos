# NixOS Config

Hardware: ASUS Zenbook 14 OLED (UX3405M) 2024

## Editing and applying the config

```bash
sudo $EDITOR /etc/nixos/configuration.nix

# Switch immediately
sudo nixos-rebuild switch
# Switch only after next boot
sudo nixos-rebuild boot
# Test
sudo nixos-rebuild test

# After switching hostname
sudo nixos-rebuild switch --flake .#nixbox
```

## Upgrade and cleanup

```bash
# Upgrade system (Flake lock)
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch

# List and clean up previous generations
sudo nix-store --gc --print-roots
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-env --delete-generations 10d
# or
sudo nix-collect-garbage --delete-older-than 1d
```

## How this Git repo was initialized

```bash
cd /etc/nixos/
sudo git config --global init.defaultBranch main
sudo git init
sudo git config --global user.email "root@localhost"
sudo git config --global user.name "root"
```
