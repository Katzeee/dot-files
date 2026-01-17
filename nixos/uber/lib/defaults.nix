{ inputs, ... }:
{
  inherit inputs;
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
}
