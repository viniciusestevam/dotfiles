require("monokai").setup {
  pattern = require('monokai').pro
}

vim.cmd "hi SignColumn guibg=NONE"
vim.cmd "hi VertSplit guibg=NONE"
vim.cmd "hi LineNr guibg=NONE"
vim.cmd "hi normal guibg=NONE ctermbg=NONE"
vim.cmd "hi DiffAdd guifg=#81A1C1 guibg=NONE"
vim.cmd "hi DiffChange guifg=#3A3E44 guibg=NONE"
vim.cmd "hi DiffModified guifg=#FFD866 guibg=NONE"
