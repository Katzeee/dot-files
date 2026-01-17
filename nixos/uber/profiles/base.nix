{ config, pkgs, ... }:

{
  imports = [
    ../modules/nix/settings.nix
    ../modules/system/locale.nix
    ../modules/system/timezone.nix
    ../modules/system/ssh.nix
    ../modules/system/networking.nix
    ../modules/apps/cli-tools.nix
  ];
}
