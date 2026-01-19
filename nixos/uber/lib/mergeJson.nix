{ lib, pkgs }:
let
  mergeFn = ''
    merge_json() {
      local path="$1"
      local patch="$2"
      local base="{}"
      if [ -f "$path" ]; then
        if ${pkgs.jq}/bin/jq -e . "$path" >/dev/null 2>&1; then
          base="$(cat "$path")"
        fi
      fi
      printf '%s\n%s\n' "$base" "$(cat "$patch")" \
        | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' > "$path"
    }
  '';
in
{
  mkActivation = { name, entries, when ? true }:
    lib.mkIf when (lib.hm.dag.entryAfter [ "writeBoundary" ] (''
      ${mergeFn}
    '' + lib.concatMapStrings (entry: ''
      merge_json "${entry.path}" "${entry.patch}"
    '') entries));
}
