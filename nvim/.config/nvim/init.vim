" ~/.config/nvim/init.vim

" basic display settings
set number
set ruler
syntax on

" no swap files
set noswapfile
set nobackup
set nowritebackup

" encoding
set encoding=utf-8

" indenct
set expandtab
set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set list listchars=tab:▸\ ,trail:·
set nofixeol

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" file systems
set autochdir

" search
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
autocmd QuickFixCmdPost *grep* cwindow

" mouse scrolling
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" clipboard
set clipboard=unnamedplus

" plugins
if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy':0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
filetype plugin indent on
syntax enable

" autoload configs
for f in glob('$HOME/.config/nvim/autoload/*.vim', 0, 1)
  exe 'source' f
endfor

" local config
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
if has('win32')
  let $MYLOCALVIMRC = $HOME . "/_local.vim"
else
  let $MYLOCALVIMRC = $HOME . "/.local.vim"
endif
call SourceIfExists($MYLOCALVIMRC)

