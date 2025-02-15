# NixOS Config

Hardware: ASUS Zenbook 14 OLED (UX3405M) 2024

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
nix-store --gc --print-roots
nix-env --list-generations --profile /nix/var/nix/profiles/system
nix-env --delete-generations 10d
# or
nix-collect-garbage --delete-older-than 1d
```

## How this Git repo was initialized

```bash
cd /etc/nixos/
git config --global init.defaultBranch main
git init
git config --global user.email "root@localhost"
git config --global user.name "root"
```
