{ config, pkgs, ... }:

{
  nix.settings.substituters = ["https://mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org/"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}
