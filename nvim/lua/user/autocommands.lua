local function open_nvim_tree(data)
  if vim.fn.isdirectory(data.file) == 0 then
    vim.cmd.cd(vim.fs.dirname(data.file))
  else
    require("nvim-tree.api").tree.open()
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
    pattern = "NvimTree_*",
    callback = function()
      local layout = vim.api.nvim_call_function("winlayout", {})
      if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
        vim.cmd("confirm quit")
      end
    end
})

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
