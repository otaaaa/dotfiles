let loaded_matchparen = 1
let g:python3_host_prog = '/usr/bin/python3'
set noundofile
set backspace=indent,eol,start
"set autoread
set nu
set ruler
set cursorline
"set cursorcolumn
set expandtab
set shiftwidth=2
"set nowrap
set hlsearch
set tabstop=2
"set list
set softtabstop=2
set autoindent
set smartindent
set noswapfile
set nobackup
set noequalalways
set imdisable
set ambiwidth=double
"set mouse=a

highlight LineNr ctermfg=238 ctermbg=none
highlight CursorLine cterm=none ctermbg=238 guibg=black
highlight CursorColumn cterm=none ctermbg=238 guibg=black
highlight Visual cterm=none ctermbg=240 guibg=black

augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter,BufRead * set cursorline
augroup END

"paste mode
set pastetoggle=<C-p>

"Required!
filetype plugin indent on

"set cursorcolumn
nnoremap <Space>c :<C-u>setlocal cursorcolumn!<CR>

"move window
noremap <S-TAB> <C-w>W
noremap <TAB> <C-w>w

" :only alias
nmap <Space>o :only<CR>

" VimFiler [http://eed3si9n.com/ja/vim-memo]
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
nnoremap <silent> <Space>e :<C-U>VimFiler -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>

"disable arrow keys
noremap j gj
noremap k gk
noremap $ g$
noremap 0 g0
noremap A g$a

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <UP> <Nop>
inoremap <Down> <Nop>
inoremap <RIGHT> <Nop>
inoremap <LEFT> <Nop>
inoremap <c-a> <END>
inoremap <c-0> <HOME>

set fileformats=unix,dos,mac

" colorscheme
colorscheme iceberg

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:toml_dir = expand('~/.config/nvim')
let s:toml = s:toml_dir . '/dein.toml'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

let g:terraform_fmt_on_save = 1
