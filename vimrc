" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" alternatively, pass a path where Vundle should install bundles
"let path = '~/some/path/here'
"call vundle#rc(path)

" let Vundle manage Vundle, required
Bundle 'gmarik/Vundle.vim'

" Keep bundle commands between here and filetype plugin indent on.
" scripts on GitHub repos
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-sleuth'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-rails.git'
Bundle 'davidhalter/jedi-vim'
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'mbbill/undotree'
Bundle 'plasticboy/vim-markdown'

filetype plugin indent on     " required

" Put your stuff after this line
" ---------------------------------------------------------------------------

" Bundles' configuration
nnoremap <F3> :NERDTreeToggle<cr>
nnoremap <F5> :UndotreeToggle<cr>
let g:undotree_WindowLayout = 3

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

set colorcolumn=+1		" show line to indicate character limit
set number			" show line number
set background=dark		" default terminal background
set clipboard=unnamedplus	" alias unnamed register to the + register
set smartcase			" only be case sensitive when it matters!

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
