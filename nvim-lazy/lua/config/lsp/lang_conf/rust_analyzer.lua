return {
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = true,
			},
			inlayHints = {
				lifetimeElisionHints = {
					enable = true,
				},
				bindingModeHints = {
					enable = true,
				},
			},
			completion = {
				-- limit = 1,
			},
			checkOnSave = {
				-- enable = false,
				command = "clippy",
			},
		},
	},
}
