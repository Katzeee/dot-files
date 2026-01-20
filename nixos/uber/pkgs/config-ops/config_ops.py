#!/usr/bin/env python3
import json
import os
import sys
import tempfile
from pathlib import Path

from ruamel.yaml import YAML
import tomlkit
from configupdater import ConfigUpdater


def load_doc(fmt: str, path: Path):
    if not path.exists():
        return empty_doc(fmt)

    data = path.read_text(encoding="utf-8")
    if fmt == "json":
        return json.loads(data) if data.strip() else {}
    if fmt == "yaml":
        yaml = YAML()
        return yaml.load(data) if data.strip() else {}
    if fmt == "toml":
        return tomlkit.parse(data) if data.strip() else tomlkit.document()
    if fmt == "ini":
        cfg = ConfigUpdater()
        cfg.read_string(data)
        return cfg
    raise ValueError(f"unsupported format: {fmt}")


def save_doc(fmt: str, doc, path: Path):
    if fmt == "json":
        text = json.dumps(doc, ensure_ascii=False, indent=2) + "\n"
    elif fmt == "yaml":
        yaml = YAML()
        yaml.indent(sequence=2, offset=2)
        import io
        buf = io.StringIO()
        yaml.dump(doc, buf)
        text = buf.getvalue()
    elif fmt == "toml":
        text = tomlkit.dumps(doc)
        if not text.endswith("\n"):
            text += "\n"
    elif fmt == "ini":
        text = str(doc)
        if not text.endswith("\n"):
            text += "\n"
    else:
        raise ValueError(f"unsupported format: {fmt}")

    atomic_write(path, text)


def empty_doc(fmt: str):
    if fmt in ("json", "yaml"):
        return {}
    if fmt == "toml":
        return tomlkit.document()
    if fmt == "ini":
        return ConfigUpdater()
    raise ValueError(f"unsupported format: {fmt}")


def atomic_write(path: Path, text: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=".configops.", dir=str(path.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(text)
        os.replace(tmp, path)
        try:
            os.chmod(path, 0o600)
        except PermissionError:
            pass
    finally:
        try:
            os.unlink(tmp)
        except FileNotFoundError:
            pass


def parse_path(p: str):
    out = []
    buf = ""
    i = 0
    while i < len(p):
        ch = p[i]
        if ch == ".":
            if buf:
                out.append(buf)
                buf = ""
            i += 1
        elif ch == "[":
            if buf:
                out.append(buf)
                buf = ""
            j = p.index("]", i)
            out.append(int(p[i + 1:j]))
            i = j + 1
        else:
            buf += ch
            i += 1
    if buf:
        out.append(buf)
    return out


def set_value(doc, path_str: str, value):
    keys = parse_path(path_str)
    cur = doc
    for k in keys[:-1]:
        if isinstance(k, int):
            if not isinstance(cur, list):
                raise TypeError(f"path requires list at {k}")
            while len(cur) <= k:
                cur.append({})
            cur = cur[k]
        else:
            if not isinstance(cur, dict):
                raise TypeError(f"path requires dict at {k}")
            if k not in cur or cur[k] is None:
                cur[k] = {}
            cur = cur[k]

    last = keys[-1]
    if isinstance(last, int):
        if not isinstance(cur, list):
            raise TypeError("final container must be list")
        while len(cur) <= last:
            cur.append(None)
        cur[last] = value
    else:
        if not isinstance(cur, dict):
            raise TypeError("final container must be dict")
        cur[last] = value


def delete_key(doc, path_str: str):
    keys = parse_path(path_str)
    cur = doc
    for k in keys[:-1]:
        cur = cur[k]
    last = keys[-1]
    if isinstance(last, int):
        cur.pop(last)
    else:
        cur.pop(last, None)


def read_value(op):
    if "fromFile" in op and op["fromFile"] is not None:
        v = Path(op["fromFile"]).read_text(encoding="utf-8")
        return v.rstrip("\n")
    if "value" in op:
        return op["value"]
    if "fromEnv" in op:
        return os.environ.get(op["fromEnv"], "")
    return None


def guess_format(path: Path, explicit: str | None):
    if explicit:
        return explicit
    ext = path.suffix.lower().lstrip(".")
    if ext in ("json", "yaml", "yml", "toml", "ini"):
        return "yaml" if ext == "yml" else ext
    raise ValueError(f"missing format for {path}")


def apply_ops(fmt, doc, ops):
    for op in ops:
        kind = op.get("op", "set")
        path = op["path"]
        if kind == "set":
            val = read_value(op)
            set_value(doc, path, val)
        elif kind == "delete":
            delete_key(doc, path)
        else:
            raise ValueError(f"unsupported op: {kind}")


def main():
    if len(sys.argv) != 3 or sys.argv[1] != "apply":
        print("usage: configops apply <spec.json>", file=sys.stderr)
        sys.exit(2)

    spec_path = Path(sys.argv[2])
    spec = json.loads(spec_path.read_text(encoding="utf-8"))

    for f in spec["files"]:
        target = Path(os.path.expanduser(f["path"]))
        fmt = guess_format(target, f.get("format"))
        ops = f["ops"]

        doc = load_doc(fmt, target)
        apply_ops(fmt, doc, ops)
        save_doc(fmt, doc, target)


if __name__ == "__main__":
    main()
