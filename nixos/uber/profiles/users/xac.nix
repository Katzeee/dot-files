{ config, pkgs, ... }:

{
  home-manager.users.xac = import ../../home/users/xac/default.nix;
}
