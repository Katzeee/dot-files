{ config, pkgs, ... }:

{
  nix.settings.substituters = ["https://mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org/"];
  nixpkgs.config.allowUnfree = true;
}
