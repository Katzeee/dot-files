{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
  ];

  home.stateVersion = "25.11";
}
