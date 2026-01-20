{ config, lib, pkgs, ... }:

{
  config = {
    nixpkgs.overlays = [
      (final: prev: import ../../pkgs { inherit (prev) lib callPackage; })
    ];
  };
}
