{ config, pkgs, ... }:

{
  imports = [
    ../../modules/dev/nodejs.nix
    ../../modules/tools/claude-cli.nix
  ];

  claude.enable = true;
  claude.provider = "glm";

  home.packages = [ pkgs.happy-cli ];

  home.stateVersion = "25.11";
}
