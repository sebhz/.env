vim.opt.ls = 2                -- always show status line
vim.opt.expandtab = true      -- replace tabs by spaces
vim.opt.tabstop = 4           -- numbers of spaces of tab character
vim.opt.shiftwidth = 4        -- numbers of spaces to (auto)indent
vim.opt.scrolloff = 3         -- keep 3 lines when scrolling
vim.opt.showcmd = true        -- display incomplete commands
vim.opt.hlsearch = true       -- highlight searches
vim.opt.incsearch = true      -- do incremental searching
vim.opt.ruler = true          -- show the cursor position all the time
vim.opt.visualbell = t_vb     -- turn off error beep/flash
vim.opt.backup = false        -- do not keep a backup file
vim.opt.number = true         -- show line numbers
vim.opt.ignorecase = true     -- ignore case when searching
vim.opt.title = true          -- show title in console title bar
vim.opt.ttyfast = true        -- smoother changes
vim.opt.modeline = true       -- last lines in document sets vim mode
vim.opt.modelines = 3         -- number lines checked for modelines
vim.opt.shortmess = "atI"     -- Abbreviate messages
vim.opt.startofline = false   -- don't jump to first character when paging
vim.opt.whichwrap = "b,s,h,l" -- move freely between files
vim.opt.mouse=""              -- mouse is evil

-- autoindent is painful
vim.opt.autoindent = false
vim.opt.smartindent = false
vim.opt.cindent = false

-- Arrows are bad
for k, v in pairs({'<Up>', '<Down>', '<Left>', '<Right>'}) do
    vim.keymap.set('n', v, '<Nop>')
end

-- Syntax coloring
vim.opt.background = 'dark'
vim.cmd [[syntax on]]
vim.cmd [[colorscheme peaksea]]

-- No tab expansion for makefiles
-- 2 spaces tabs for shell files
-- TODO: go full Lua and use 'callback' option instead of 'command' Ex string
autocmd_filetype_tbl = {
    make=[[set noexpandtab]],
    sh=[[setlocal tabstop=2 shiftwidth=2 softtabstop=2]]
}
for pat, cmd in pairs(autocmd_filetype_tbl) do
    vim.api.nvim_create_autocmd("FileType", { pattern = pat, command = cmd })
end

-- Extra and dangling whitespace highlighting
local ag = vim.api.nvim_create_augroup('show_whitespaces', {clear = true})
vim.api.nvim_create_autocmd(
    'Syntax', {
        pattern = '*',
        command = [[syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL]],
        group = ag,
    })
vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=red]]

