# Neovim configuration

This configuration supports two explicit rendering capabilities:

- `ascii` (default): only ASCII symbols are emitted by the configuration. Nerd
  glyphs are either omitted when they are merely decorative (for example file
  and directory icons), or replaced with semantic labels such as `M`
  (modified) and `E` (error). This portable fallback retains useful information
  without producing missing-glyph boxes.
- `nerd`: Nerd Font icons and file icons are enabled.

Start Neovim with Nerd Font support:

```sh
NVIM_ICON_MODE=nerd nvim
```

To enable it permanently, export the variable in the shell profile used to
launch Neovim:

```sh
export NVIM_ICON_MODE=nerd
```

Run `:IconInfo` to inspect the active mode. If the configured terminal font is
changed, restart Neovim with `NVIM_ICON_MODE=ascii` until a Nerd Font or a
Symbols Nerd Font fallback is available.

Font fallback is a terminal responsibility. Neovim cannot query glyph coverage
from a terminal, so this configuration deliberately does not guess based on
`TERM`, operating system, or terminal brand.

The rendering layer is intentionally separated from plugin configuration:

```text
lua/core/icons/init.lua
lua/core/icons/profiles/ascii.lua
lua/core/icons/profiles/nerd.lua
```

Profiles are data-only. Plugins consume `core.icons` and never select glyphs
or infer font capabilities themselves.
