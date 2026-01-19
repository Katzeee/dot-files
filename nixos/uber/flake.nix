{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      mkHost = import ./lib/mkHost.nix { inherit lib inputs; };
    in
    {
      nixosConfigurations = {
        vm-nixos = mkHost {
          system = "x86_64-linux";
          modules = [
            ./hosts/vm-nixos/default.nix
          ];
        };
      };
    };
}
