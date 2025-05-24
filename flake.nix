{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ({pkgs, ...}: {
          imports = [./configuration.nix];

          nixpkgs.overlays = [
            (final: prev: {
              unstable = unstable.legacyPackages.${system};
            })
          ];
        })
      ];
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
