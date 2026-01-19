{ lib, pkgs }:
{
  mkTemplateReplace = {
    templatePath,
    replacements,
  }:
  let
    replacementsJson = builtins.toJSON (map (item: {
      placeholder = item.placeholder;
      path = item.path;
      escape = item.escape or "none";
    }) replacements);
  in
  {
    renderCmd = ''
      ${pkgs.python3}/bin/python - <<'PY'
import json
from pathlib import Path

replacements = json.loads(r'''${replacementsJson}''')
text = Path("${templatePath}").read_text()

for item in replacements:
    placeholder = item["placeholder"]
    value = Path(item["path"]).read_text()
    if value.endswith("\n"):
        value = value[:-1]
    if item.get("escape") == "json":
        value = json.dumps(value)[1:-1]
    text = text.replace(placeholder, value)

print(text, end="")
PY
    '';
  };
}
