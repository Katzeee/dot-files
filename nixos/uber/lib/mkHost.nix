{ lib }:
{ hostname, system, modules }:
lib.nixosSystem {
  inherit system;
  modules = modules;
}
