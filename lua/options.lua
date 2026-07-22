-- Editor options. Small-screen first (MNT Pocket Reform), scales to 1440p.
local opt = vim.opt

-- Lines
opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.cursorline = true

-- Wrapping (small screens wrap a lot — make it readable)
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.scrolloff = 3
opt.sidescrolloff = 4

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Windows
opt.splitright = true
opt.splitbelow = true
opt.equalalways = false

-- Indent (2-space default; gofmt/ruff/prettier normalize on save)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Files: autosave + autoreload (agent-friendly by design)
opt.undofile = true
opt.autowrite = true
opt.autoread = true
opt.updatetime = 250

-- Mouse: full support, right-click opens a menu without moving the cursor
opt.mouse = "a"
opt.mousemodel = "popup"

-- UI: globalstatus saves a row on small screens; cmdline hidden until used.
-- (No global winborder — it breaks statusline rendering; floats set their
-- own sharp "single" borders instead.)
opt.termguicolors = true
opt.laststatus = 3
opt.cmdheight = 0
opt.showmode = false
opt.fillchars = { eob = " " }
opt.shortmess:append "c"

opt.completeopt = { "menu", "menuone", "noselect" }
opt.clipboard = "unnamedplus"
