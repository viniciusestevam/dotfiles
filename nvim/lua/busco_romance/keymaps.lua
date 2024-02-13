-- ESC mappings
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "<C-c>", "<Esc>")

-- set leader as space
vim.g.mapleader = " "

-- executes Ex commands (:)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- moves lines up and down with JK in VisualMode
-- and keep the cursor on the current line
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

-- keep the current line on the center when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep the selected line on the center when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete to blackhole register 
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- disable Ex mode with Q
vim.keymap.set("n", "Q", "<nop>")

-- format with LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- navigate through errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- navigate through location list https://freshman.tech/vim-quickfix-and-location-list/
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- globally replace the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left>]])

-- makes the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- copied from prime > re-sources the current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
