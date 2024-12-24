scriptencoding utf-8

set encoding=utf-8
set termguicolors
set nocompatible       " Forget old vi
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set autowrite          " Autom... save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set number
set tabstop=4          " a tab is four spaces
set expandtab          " Expand tabs to spaces by default
set shiftwidth=4       " number of spaces to use for autoindenting
set shiftround         " use multiple of shiftw.. when ind.. with '<' and '>'
set backspace=indent,eol,start  " allow backsp.. over everyth.. in insert mode
set autoindent         " always set autoindenting on
set copyindent         " copy the previous indentation on autoindenting
set mouse=a
" white space characters
set nolist
" compatible space chars
set listchars=eol:↓,tab:→\ ,trail:●,extends:>,precedes:<,nbsp:_
" incompatible with debian stretch
"set listchars=eol:↓,tab:\ \ ┊,trail:●,extends:…,precedes:…,space:·
highlight SpecialKey term=standout ctermfg=darkgray guifg=darkgray
" display white space characters with F3
nnoremap <F3> :set list! list?<CR>

let mapleader = " " " map leader to Space

" no indent on paste
set pastetoggle=<F2>
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set noshowmode " duplicated by status line plugin

syntax enable
" filetype on                  " required

" soft wrap
set wrap
set linebreak

filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'FuzzyFinder'
Plugin 'L9'
call vundle#end()            " required
filetype plugin indent on    " required

packadd termdebug
let g:termdebug_wide=1

map <C-F5> :Run<CR>
map <F5> :Continue<CR>
map <F7> :Over<CR>
map <F8> :Step<CR>
map <F6> :Finish<CR>
map <F9> :Break<CR>
map <S-F9> :Clear<CR>
