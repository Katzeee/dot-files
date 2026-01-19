{ lib, pkgs }:
let
  mergeFn = ''
    set -euo pipefail

    merge_json() {
      local path="$1"
      local patch="$2"
      (
        local dir tmp
        dir="$(dirname "$path")"
        mkdir -p "$dir"
        tmp="$(mktemp -p "$dir" .jsonmerge.XXXXXX)"
        trap 'rm -f "$tmp"' EXIT

        if [ -f "$path" ] && ${pkgs.jq}/bin/jq -e . "$path" >/dev/null 2>&1; then
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$path" "$patch" > "$tmp"
        else
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' <(printf '{}') "$patch" > "$tmp"
        fi

        mv "$tmp" "$path"
      )
    }
  '';

in
{
  mkActivation = { entries }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] (mergeFn
      + lib.concatMapStrings (entry:
        let
          kind = entry.patch.kind or null;
          value = entry.patch.value or null;
          validKind = kind != null && builtins.elem kind [ "path" "cmd" ];
          validValue = value != null && value != "";
        in
          lib.assertMsg
            (validKind && validValue)
            "mkJsonMerge: entry.patch.kind must be one of [ \"path\" \"cmd\" ] and entry.patch.value must be set."
            ''
        ${
          if kind == "cmd" then ''
            (
              patch_path="$(mktemp)"
              trap 'rm -f "$patch_path"' EXIT
              ${entry.patch.value} > "$patch_path"
              merge_json "${entry.path}" "$patch_path"
            )
          '' else ''
            merge_json "${entry.path}" "${entry.patch.value}"
          ''
        }
      '') entries);
}
