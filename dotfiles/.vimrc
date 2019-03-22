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

Plug 'jiangmiao/auto-pairs'
Plug 'vim-syntastic/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()

" ============================================
" Editor Options
" ============================================
if !exists('g:os')
  if has('win64') || has ('win32') || has('win16')
    let g:os = 'Windows'
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif

" Already set by vim-plug but kept here for clarity
syntax on
syntax enable
filetype plugin indent on

if (has("termguicolors"))
  set termguicolors
endif

if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif

colorscheme desert

let mapleader=";"
set laststatus=2
set statusline+=%f
set number
set mouse=v
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent
set cursorline
set wildmenu
set showmatch
set splitbelow
set splitright
set nospell
set incsearch
set hlsearch
set updatetime=1000
set runtimepath^=~/.vim/bundle/ctrlp.vim

" easy navigation between splits with the alt key
" mapped for the option key on mac
nmap ˙ <C-w><Left>
nmap ¬ <C-w><Right>
nmap ˚ <C-w><Up>
nmap ∆ <C-w><Down>
nmap √ <C-w>v
nmap ß <C-w>s

match SpellRare /\s\+$/ " highlight trailing whitespace

" ============================================
" Tagbar
" ============================================
set tags+=.git/tags;~
" map ctrl-t to tagbar toggle
map <C-t> :TagbarOpen j<CR>

" ============================================
" Silver Searcher
" ============================================
" Map grep to ag
if executable('ag')
  " Use ag over grep
  set grepprg=ag\

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ============================================
" Auto-Formatting
" ============================================
map <C-K> :Autoformat<cr>
imap <C-K> <c-o>:Autoformat<cr>

" Shortcut to remove trailing whitespace in a file
:nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" ============================================
" FZF
" ============================================
" add fzf
if g:os == 'Darwin'
  set rtp+=/usr/local/opt/fzf
elseif g:os == 'Linux'
  set rtp+=~/.fzf
endif
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
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_enable_yaml_checker = 1
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_php_checkers = ['phpcs']
let g:syntastic_javascript_checkers = ['eslint']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Autoclose YCM Preview Window
let g:ycm_autoclose_preview_window_after_completion=1

" autocomplete settings
set completeopt+=menuone

