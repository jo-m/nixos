#!/usr/bin/env bash

set -euxo pipefail

cd /etc/nixos
nix flake update
nixos-rebuild switch
git add flake.lock
git commit -m 'upgrade'
