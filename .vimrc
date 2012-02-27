" VIM Configuration File

" allows backspace over anything
set backspace=indent,eol,start

" show whitespace
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" tabs and auto-indent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" setting terminal colors
set t_Co=256

" show status bar
set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

colors zenburn

" syntax
syntax on
let g:sql_type_default = "sqlserver"
