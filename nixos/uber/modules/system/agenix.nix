{ inputs, pkgs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.identityPaths = [ "/etc/agenix/age.key" ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.agenix
  ];
}
