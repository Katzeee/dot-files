{ lib, pkgs, configOps ? pkgs.configOps }:

let
  json = pkgs.formats.json { };

  mkSpec = name: { files }:
    json.generate "${name}.configops.json" { inherit files; };
in
{
  mkActivation = { name, files }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -euo pipefail
      umask 077
      ${configOps}/bin/configops apply ${mkSpec name { inherit files; }}
    '';
}
