{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      mkHost = import ./lib/mk-host.nix { inherit lib inputs; };
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        vm-nixos = mkHost {
          system = system;
          modules = [
            ./hosts/vm-nixos/default.nix
          ];
        };
      };
    };
}
