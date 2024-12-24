scriptencoding utf-8

set encoding=utf-8
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set autowrite          " Autom... save before commands like :next and :make

" Нуамерация строк
set nu
" Четыре пробела заместо таба
set tabstop=4 shiftwidth=4 expandtab
" Заперищает vi вместо vim
set nocompatible " be iMproved, required
" Интеграция мыши
set mouse=a
" Язык файлов помощи
set helplang=ru

set colorcolumn=81
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

command! Pandoc
    \ execute ':silent !pandoc -o /tmp/TEMP.html %'
    \ | execute ':redraw!'

"filetype off                  " required
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
"call vundle#end()            " required
"filetype plugin indent on    " required
"
" Установка и настройка Termdebug
packadd! termdebug
let g:termdebug_wide=1
map <C-F5> :Run<CR>
map <F5> :Continue<CR>
map <F7> :Over<CR>
map <F8> :Step<CR>
map <F6> :Finish<CR>
map <F9> :Break<CR>
map <S-F9> :Clear<CR>

