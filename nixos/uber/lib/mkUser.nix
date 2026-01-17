{ lib }:
{ username, modules }:
lib.homeManagerConfiguration {
  modules = modules;
}
