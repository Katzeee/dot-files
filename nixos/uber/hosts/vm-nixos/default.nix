{ config, pkgs, ... }:

{
  imports = [
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../profiles/vm.nix
    ../../profiles/users/xac.nix

    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
  ];

  system.stateVersion = "25.11";
}
