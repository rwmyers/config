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

colors molokai

" syntax
syntax on
let g:sql_type_default = "sqlserver"
let g:build_type_default = "xml"

map <M-Right> :bn!<CR>
map <M-Left> :bp!<CR>

" minibufexpl
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

" filetypes
filetype on
au BufNewFile,Bufread *.build set filetype=xml
au BufNewFile,BufRead *.gradle setf groovy
