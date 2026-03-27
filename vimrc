" ── vim-plug bootstrap ────────────────────────────────────────
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ── Plugins ──────────────────────────────────────────────────
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
call plug#end()

" ── Theme ────────────────────────────────────────────────────
set background=dark
let g:gruvbox_contrast_dark = 'medium'
silent! colorscheme gruvbox

" ── Core ─────────────────────────────────────────────────────
syntax on
set number
set cursorline
set colorcolumn=80
set scrolloff=8
set signcolumn=yes
set wildmenu
set wildmode=longest:full,full

" ── Search ───────────────────────────────────────────────────
set hlsearch
set incsearch
set ignorecase
set smartcase

" ── Indentation ──────────────────────────────────────────────
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
