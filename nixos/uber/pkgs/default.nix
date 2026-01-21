{ lib, callPackage }:

{
  configOps = callPackage ./config-ops { };
  claude-cli = callPackage ./claude-cli.nix { };
}
