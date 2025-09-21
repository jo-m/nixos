# NixOS Config

Hardware: ASUS Zenbook 14 OLED (UX3405M) 2024

Note that dotfiles are managed in a [separate repo via chezmoi](https://github.com/jo-m/dotfiles), to maintain easy compatibility with OSes other than NixOS.

## Editing and applying the config

```bash
$EDITOR /etc/nixos/configuration.nix

# Switch immediately
nixos-rebuild switch
# Switch only after next boot
nixos-rebuild boot
# Test
nixos-rebuild test

# After switching hostname
nixos-rebuild switch --flake .#nixbox
```

## Upgrade and cleanup

```bash
# Upgrade system (Flake lock)
cd /etc/nixos
nix flake update
nixos-rebuild switch

# List and clean up previous generations
nixos-rebuild list-generations
nix-collect-garbage --delete-older-than 30d
```

## How this Git repo was initialized

```bash
cd /etc/nixos/
git config --global init.defaultBranch main
git init
git config --global user.email "root@localhost"
git config --global user.name "root"
```
