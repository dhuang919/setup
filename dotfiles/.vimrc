" ============================================
" Plugin Management (vim-plug)
" ============================================

" Install vim-plug if it is not there already. Bootstrapping!
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start installing plugins. We use .vim/bundle for backwards compatibility
" because we used to use pathogen and its just easier to not move things
" around on machines that already use the bundle directory.
call plug#begin('~/.vim/bundle')

Plug 'mhartington/oceanic-next'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-syntastic/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()

" ============================================
" Editor Options
" ============================================
" Already set by vim-plug but kept here for clarity
syntax on
syntax enable
filetype plugin indent on

if (has("termguicolors"))
  set termguicolors
endif

let mapleader=","
set number "line numbers

set mouse=a "scrolling
set background=dark

let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

set clipboard=unnamedplus

set ts=4
set expandtab
set shiftwidth=2
set smartindent
set cursorline
set wildmenu
set showmatch

" Spell Checking
set spelllang=en
set spell

" ============================================
" Silver Searcher 
" ============================================
" Map grep to ag
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ 

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
   let g:ctrlp_use_caching = 0
endif

" ============================================
" FZF
" ============================================
" add fzf
set rtp+=/usr/local/opt/fzf
" some key bindings for fzf
" search current buffer
map <C-F> :BLines<CR>
" search for file in directory
map <C-P> :Files<CR>

" For netrw
set nocp
filetype plugin on

set backspace=indent,eol,start
set ruler

" ============================================
" Linting and Completion
" ============================================
" Syntastic Checkers
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_enable_yaml_checker = 1
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_php_checkers = ['phpcs']
let g:syntastic_javascript_checkers = ['eslint']
