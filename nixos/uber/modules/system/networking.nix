{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved.enable = true;
  services.resolved.settings = {
    Resolve = {
      DNS = [ "223.5.5.5" "223.6.6.6" ];
      FallbackDNS = [ "114.114.114.114" "1.1.1.1" "8.8.8.8" ];
    };
  };
}
