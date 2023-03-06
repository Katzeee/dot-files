local M = {}

function M.before()
end

function M.after()
end

function M.load()
  vim.cmd [[
" try
"   colorscheme darkplus
" catch /^Vim\%((\a\+)\)\=:E185/
"   colorscheme default
"   set background=dark
" endtry

" Important!!
if has('termguicolors')
  set termguicolors
endif
" For dark version.
set background=dark
" For light version.
" set background=light
" Set contrast.
" This configuration option should be placed before `colorscheme everforest`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'soft'
" For better performance
let g:everforest_better_performance = 1
colorscheme everforest
]]
end

return M
