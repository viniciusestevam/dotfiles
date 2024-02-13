require ("busco_romance.options")
require ("busco_romance.keymaps")
require ("busco_romance.init_lazy")


local autocmd = vim.api.nvim_create_autocmd

-- remove trailing spaces after writing the buffer
local augroup = vim.api.nvim_create_augroup
local group = vim.api.nvim_create_augroup('trailing-spaces', {})

autocmd({"BufWritePre"}, {
    group = group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

