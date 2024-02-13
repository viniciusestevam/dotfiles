local options = {
  fileencoding = "utf-8",                       -- standard encoding
  clipboard = "unnamedplus",                    -- shares system clipboard
  completeopt = { "menuone", "noselect", "menu" },      -- cmp compat
  colorcolumn = "80",

  hlsearch = false,                             -- disables highlight after search
  ignorecase = true,                            -- ignore case on search
  smartcase = true,                             -- smart case for searches
  incsearch = true,                             -- incremental search

  backup = false,                               -- disable backup file
  swapfile = false,                             -- disable swap file
  hidden = true,                                -- allows "hidden" buffers
  writebackup = false,                          -- doesn't allow editing files that are being read by other programs
  undodir = os.getenv("HOME") .. "/.vim/undodir",-- set up undo directory
  undofile = true,                               -- enable undo directory


  tabstop = 4,                                  -- 4 spaces for a tab
  expandtab = true,                             -- convert tabs to spaces
  wrap = false,                                 -- doesnt wraps lines
  smartindent = true,                           -- smart indentation
  shiftwidth = 4,                               -- 4 spaces for indentation

  number = true,                                -- set numbered lines
  relativenumber = true,                        -- relative number line
  numberwidth = 2,                              -- smaller number column
  pumheight = 10,                               -- popup menu height
  cmdheight = 2,                                -- more space in the neovim command line for displaying messages
  showtabline = 2,                              -- always shows tabs
  signcolumn = "yes",                           -- enables sign column
  showmode = true,                              -- doenst shows the editor mode
  scrolloff = 8,                                -- scrolls the editor with a offset of 8 lines vertically
  sidescrolloff = 8,                            -- scrolls the editor with a offset of 8 lines horizontally

  updatetime = 50,                              -- default 4000ms
  termguicolors = true,                         -- graphical interface colors
  mouse = "a",                                  -- allow mouse interactions
  guicursor = "",                               -- always block cursor
  autochdir = true                              -- always change to current buffer directory
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

