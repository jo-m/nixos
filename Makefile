
.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake . -L

.PHONY: upgrade
upgrade:
	nix flake update
	sudo nixos-rebuild switch --flake . -L
	git add flake.lock
	git commit -m 'upgrade'

.PHONY: pullpush
pullpush:
	git pull origin main
	git push gh main

.PHONY: format
format:
	nix fmt .

.PHONY: build
build:
	nixos-rebuild build --flake . -L
