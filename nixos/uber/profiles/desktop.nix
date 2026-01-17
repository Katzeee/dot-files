{ config, pkgs, ... }:

{
  imports = [
    ../modules/desktop/x11.nix
    ../modules/desktop/kde.nix
    ../modules/desktop/audio-pipewire.nix
    ../modules/services/printing.nix
    ../modules/apps/browsers.nix
  ];
}
