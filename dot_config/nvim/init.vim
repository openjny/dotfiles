" init.vim — minimal neovim config (no plugin manager)

" General
set number
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set ignorecase
set smartcase
set incsearch
set hlsearch
set termguicolors
set mouse=a
set clipboard=unnamedplus
set signcolumn=yes
set updatetime=300

" Key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <Esc> :nohlsearch<CR>
