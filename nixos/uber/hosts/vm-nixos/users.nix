{ config, pkgs, ... }:

{
  users.users.xac = {
    isNormalUser = true;
    description = "xac";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
