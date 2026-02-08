# CLAUDE.md

## Overview

NixOS configuration for ASUS Zenbook 14 OLED (UX3405M). Uses NixOS 25.11 with flakes and Lanzaboote for secure boot. Dotfiles are managed separately via chezmoi in a different repository.

## Common Commands

```bash
# Apply configuration immediately
sudo nixos-rebuild switch --flake . -L
# Or use make
make switch

# Build without applying (for testing)
sudo nixos-rebuild build --flake . -L
make build

# Update flake.lock and rebuild
make upgrade

# Format Nix code
make format

# Debug store size
nix build .#nixosConfigurations.nixbox.config.system.build.toplevel
nix path-info --recursive --size ./result | sort -nk2
nix path-info --closure-size --human-readable ./result

# Clean up old generations
nix-collect-garbage --delete-older-than 30d
```

## Architecture

```
flake.nix                    # Entry point, defines inputs (nixpkgs stable/unstable, lanzaboote)
    ↓
configuration.nix            # Main config, imports all modules, defines custom.unprivilegedUser option
    ├── hardware-configuration.nix  # Auto-generated, do not edit
    ├── modules/                    # All configuration modules
    │   ├── kernel-boot.nix         # Kernel, zram, secure boot (lanzaboote), LUKS
    │   ├── hardware.nix            # Intel GPU/NPU, VAAPI, DDC, QMK
    │   ├── system.nix              # Networking, timezone, locale, nix gc
    │   ├── user.nix                # User account, sudo
    │   ├── gnome-desktop.nix       # GNOME/Wayland, GDM, PipeWire
    │   ├── virt.nix                # Docker (rootless), Podman, VirtualBox
    │   ├── monitoring.nix          # Grafana, Prometheus
    │   ├── backup.nix              # Borg backup scripts
    │   ├── printscan.nix           # CUPS, SANE/Brother
    │   ├── rtl-sdr.nix             # RTL-SDR radio
    │   └── packages-*.nix          # Package sets by category
    └── overlays/                   # Package customizations
```

## Key Patterns

**Dual package sets:** Both stable (`pkgs`) and unstable (`unstablePkgs`) are available in modules. Use unstable for cutting-edge packages.

**Custom option for username:** Access via `config.custom.unprivilegedUser` instead of hardcoding.

**Module template:** Copy `modules/_template.nix` when creating new modules.

## Adding Packages

- Basic CLI utilities: `modules/packages-basic.nix`
- Development tools: `modules/packages-dev-tools.nix`
- GUI applications: `modules/packages-gui-apps.nix`
- User CLI tools: `modules/packages-user-cli.nix`
- Sysadmin tools: `modules/packages-sysadmin-cli.nix`
- GNOME extensions: `modules/packages-gnome-apps-extensions.nix`
- AI tools: `modules/packages-ai.nix`

## Guidelines

All names used in Nix language must adhere to the following naming (except some specific cases where other naming makes sense, e.g. env vars):
- local let bindings, function args: camelCase
- package names: kebab-case
- NixOS Options: kebab-case
