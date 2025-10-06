{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    lanzaboote,
  }: let
    system = "x86_64-linux";
    hostname = "nixbox";
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        lanzaboote.nixosModules.lanzaboote

        ./configuration.nix

        ({pkgs, ...}: {
          networking.hostName = hostname;
        })
      ];
      specialArgs = {
        unstablePkgs = unstable.legacyPackages.${system};
      };
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
