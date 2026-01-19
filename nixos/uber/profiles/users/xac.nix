{ config, lib, pkgs, ... }:

let
  claudeSecret = ../../secrets/claude.age;
in
{
  home-manager.users.xac = import ../../home/users/xac/default.nix;

  age.secrets.claude = lib.mkIf (builtins.pathExists claudeSecret) {
    file = claudeSecret;
    owner = "xac";
    mode = "0400";
  };
}
