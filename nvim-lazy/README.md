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

## External dependencies

Lazy manages Neovim plugins. When a plugin does not guarantee one of its
external prerequisites, register that relationship once through
`core.dependencies` and let the dependency owner choose the provider:

```lua
local mason = require("core.dependencies.providers.mason")

require("core.dependencies").register("plugin-name", {
  requires = {
    mason.package({
      package = "mason-package-name",
      attempts = 2,
      retry_delay_ms = 500,
    }),
  },
  on_ready = function()
    -- Enable only the behavior that requires the external tool.
  end,
})
```

The dependency funnel only coordinates lifecycle, completion, and error
aggregation. Each registered dependency supplies an `id` and an asynchronous
`ensure(callback)` function; providers own checking and installation policy.
The funnel reacts to Lazy's `LazyLoad` event and runs `on_ready` only after
every registered dependency is available. Dependencies already guaranteed by
a plugin's supported integration should continue to use that integration.

## Plugin organization

Plugin specs are grouped by responsibility and normally keep one primary
plugin per file:

```text
lua/plugins/
├── coding/  # completion, LSP, package management, formatting
├── core/    # shared plugin dependencies
├── debug/   # DAP and its tightly coupled integrations
├── editor/  # editing, navigation, and syntax
├── tools/   # terminal and source-control tools
└── ui/      # theme, layout, status, and notifications
```

`lua/plugins/init.lua` imports only these responsibility boundaries. Adding a
plugin requires creating a file in the appropriate directory; the central
entry point does not enumerate individual plugins.
