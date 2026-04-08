" ── vim-plug (auto-install) ────────────────────────────
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'github/copilot.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

" ── General ──────────────────────────────────────────
set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8

" ── Theme ──────────────────────────────────────────
set background=dark
if has('termguicolors')
  set termguicolors
endif
let g:gruvbox_transparent_bg = 1
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_bold = 1
silent! colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE

" ── Appearance ──────────────────────────────────────
set number
set relativenumber
set cursorline
set signcolumn=yes
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

" ── OSC 52 clipboard (works in containers/SSH) ────
" Sends text to the terminal's clipboard via OSC 52 escape sequence
function! OSC52Send(text) abort
  let encoded = system('printf ' . shellescape(a:text) . ' | base64 | tr -d "\n"')
  if has('nvim')
    call chansend(v:stderr, "\x1b]52;c;" . encoded . "\x07")
  else
    let osc = "\x1b]52;c;" . encoded . "\x07"
    call writefile([osc], '/dev/stderr', 'b')
  endif
endfunction

" Trigger on all yank/delete/change operations
autocmd TextYankPost * call OSC52Send(getreg('"'))

" Mouse selection: yank to clipboard when releasing mouse in visual mode
vnoremap <LeftRelease> y
" Also send to OSC 52 after any visual yank (covers mouse + keyboard)
vnoremap y y:call OSC52Send(getreg('"'))<CR>

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

" ── gitgutter (signs only, no keymaps) ─────────────
let g:gitgutter_map_keys = 0

" ── fzf.vim ────────────────────────────────────────
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :BLines<CR>

" ── LSP ────────────────────────────────────────────
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>f <plug>(lsp-document-format)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_signs_enabled = 1

" Format on save for Python and C/C++
augroup lsp_format
  au!
  autocmd BufWritePre *.py,*.c,*.cc,*.cpp,*.h,*.hpp call execute('LspDocumentFormatSync')
augroup END

" Use ruff for Python formatting/linting, pyright for type checking
let g:lsp_settings = {
\   'ruff': {'workspace_config': {}},
\   'pyright-langserver': {'workspace_config': {'python': {'analysis': {'typeCheckingMode': 'basic'}}}},
\   'clangd': {'cmd': ['clangd', '--background-index', '--clang-tidy']},
\ }

" asyncomplete: tab/shift-tab to navigate, enter to confirm
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" ── Create undo directory if missing ───────────────
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
