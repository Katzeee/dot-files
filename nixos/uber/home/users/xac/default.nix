{ config, pkgs, ... }:

{
  imports = [
    ../../modules/dev/nodejs.nix
    ../../modules/tools/claude-cli.nix
  ];

  claude.enable = true;

  home.stateVersion = "25.11";
}
