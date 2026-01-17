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
      mkHost = import ./lib/mkHost.nix { inherit lib; };
    in
    {
      nixosConfigurations = {
        uber = mkHost {
          hostname = "uber";
          system = "x86_64-linux";
          modules = [
            ./hosts/uber/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.xac = import ./home/users/xac/default.nix;
            }
          ];
        };
      };
    };
}
