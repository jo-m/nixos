# NixOS Config

Hardware: ASUS Zenbook 14 OLED (UX3405M) 2024

Note that dotfiles are managed in a [separate repo via chezmoi](https://github.com/jo-m/dotfiles), to maintain easy compatibility with OSes other than NixOS.

## Editing and applying the config

```bash
# Switch immediately
sudo nixos-rebuild switch --flake . -L
# Switch only after next boot
sudo nixos-rebuild boot --flake . -L
# Test
sudo nixos-rebuild test --flake . -L
sudo nixos-rebuild build --flake . -L

# After switching hostname
sudo nixos-rebuild switch --flake .#nixbox
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

# Re-generate hardware config
nixos-generate-config --dir .
```
