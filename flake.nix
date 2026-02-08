{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; # Hint: Don't forget to bump lanzaboote as well.
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    unstable,
    lanzaboote,
    ...
  }: let
    system = "x86_64-linux";
    hostname = "nixbox";
    unstablePkgs = import unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        lanzaboote.nixosModules.lanzaboote

        ./configuration.nix

        (_: {
          networking.hostName = hostname;
        })
      ];
      specialArgs = {
        inherit unstablePkgs;
      };
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    devShells.${system}.default = let
      pkgs = nixpkgs.legacyPackages.${system};
      scripts = import ./scripts.nix {inherit pkgs;};
    in
      pkgs.mkShell {
        packages = [scripts];
      };
  };
}
