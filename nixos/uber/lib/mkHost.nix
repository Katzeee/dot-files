{ lib, inputs ? { } }:
{ system ? "x86_64-linux", modules, specialArgs ? { } }:
lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; } // specialArgs;
  modules = modules ++ [
    ../modules/system/home-manager.nix
  ];
}
