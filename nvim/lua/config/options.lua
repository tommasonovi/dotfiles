local opt = vim.opt

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Use OSC 52 clipboard in headless environments (devcontainer, SSH)
-- where xclip/xsel are unavailable. Falls back to normal clipboard on macOS/desktop Linux.
if not vim.env.DISPLAY and not vim.env.WAYLAND_DISPLAY and vim.fn.has("mac") == 0 then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
    }
end
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 250
opt.timeoutlen = 400

-- Appearance
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmatch = true
opt.showcmd = true
opt.showmode = false
opt.laststatus = 2
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", extends = "›", precedes = "‹" }
opt.termguicolors = true

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true

-- Search
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Wildmenu
opt.wildmode = "longest:full,full"

-- Statusline (matches vim config)
opt.statusline = " %#CursorLineNr# %f %#Normal#%m%r%=%#CursorLineNr# %Y │ %l:%c │ %p%% "
