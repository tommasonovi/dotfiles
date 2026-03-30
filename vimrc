" ── General ──────────────────────────────────────────
set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8

" ── Theme (use terminal colors) ──────────────────────
set background=dark

" ── Appearance ──────────────────────────────────────
set number
set cursorline
set signcolumn=no
set showmatch
set showcmd
set noshowmode
set laststatus=2
set scrolloff=8
set sidescrolloff=8
set list
set listchars=tab:▸\ ,trail:·,extends:›,precedes:‹

" ── Statusline (no plugins needed) ─────────────────
set statusline=
set statusline+=\ %#CursorLineNr#
set statusline+=\ %f
set statusline+=\ %#Normal#
set statusline+=%m%r
set statusline+=%=
set statusline+=%#CursorLineNr#
set statusline+=\ %Y
set statusline+=\ │\ %l:%c
set statusline+=\ │\ %p%%\

" ── Indentation ────────────────────────────────────
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent

" ── Search ─────────────────────────────────────────
set incsearch
set hlsearch
set ignorecase
set smartcase

" ── Behavior ───────────────────────────────────────
set hidden
set mouse=a
set splitbelow
set splitright
set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start
set clipboard=unnamedplus
set updatetime=250
set timeoutlen=400
set undofile
if has('nvim')
  set undodir=~/.local/share/nvim/undo
else
  set undodir=~/.vim/undodir
endif
set noswapfile
set nobackup

" ── Keymaps ────────────────────────────────────────
let mapleader = " "

" Clear search highlight
nnoremap <Esc> :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Quick save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

" Better indenting (stay in visual mode)
vnoremap < <gv
vnoremap > >gv

" ── Netrw (built-in file explorer) ─────────────────
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
nnoremap <leader>e :Lexplore<CR>

" ── Create undo directory if missing ───────────────
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
