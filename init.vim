if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'prettier/vim-prettier'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/seoul256.vim'
Plug 'kassio/neoterm'
Plug 'vim-test/vim-test'
Plug 'w0rp/ale'
call plug#end()

colorscheme seoul256

syntax on
highlight LineNr cterm=none ctermbg=none ctermfg=Yellow
highlight CursorLineNr ctermbg=none
highlight Normal ctermbg=none
highlight Visual cterm=none ctermbg=darkgrey ctermfg=cyan

highlight GitGutterAdd    guifg=#00ff00 ctermfg=28
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff1111 ctermfg=160

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set history=1000
set clipboard=unnamedplus
set number relativenumber

set hlsearch
set ignorecase

set updatetime=50

setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

set nocompatible
filetype off

let &runtimepath.=',~/.vim/bundle/neoterm'

filetype plugin on

let mapleader="\<SPACE>"

nmap <Leader><S-s> :%s//g<Left><Left>
nmap <Leader>s :%s//c<Left><Left>

nnoremap <silent> <leader>/ :nohlsearch<CR>

" Search binds
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>p :GFiles<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>r :Rg<CR>
vnoremap <Leader>f execute "Rg " . GetVisual()<CR>

nnoremap <Leader>n :NERDTreeToggle<CR>
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

"Neoterm mappings
tnoremap <Esc> <C-\><C-n>
if has('terminal') || has('nvim')
  let g:test#strategy = 'neoterm'
  let g:neoterm_default_mod = 'rightbelow vertical'
  nmap <silent> <leader><Esc> :Ttoggle<CR>
endif

nmap <silent> <Leader>tl :TestNearest<CR>
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>ta :TestSuite<CR>
nmap <silent> <Leader>tr :TestLast<CR>


"mappings
" Switch 0 to jump to the first char
nnoremap 0 ^
nnoremap ^ 0

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Split from buffer list
nnoremap <leader>vb :ls<cr>:vertical sb<space>
nnoremap <leader>hb :ls<cr>:sb<space>


" Surround binds
" <leader># Surround a word with #{ruby interpolation}
nnoremap <leader># ciw#{<C-R>"}<ESC>
vnoremap <leader># c#{<C-R>"}<ESC>

" <leader>" Surround a word with "quotes"
nnoremap <leader>" ciw"<C-R>""<ESC>
vnoremap <leader>" c"<C-R>""<ESC>

" <leader>' Surround a word with 'single quotes'
nnoremap <leader>' ciw'<C-R>"'
vnoremap <leader>' c'<C-R>"'<ESC>

" <leader>) Surround a word with (parens)
" The difference is in whether a space is put in
nnoremap <leader>( ciw(<C-R>")<ESC>
nnoremap <leader>) ciw(<C-R>")<ESC>
vnoremap <leader>( c( <C-R>" )<ESC>
vnoremap <leader>) c(<C-R>")<ESC>

" <leader>[ Surround a word with [brackets]
nnoremap <leader>] ciw[<C-R>"]<ESC>
nnoremap <leader>[ ciw[<C-R>"]<ESC>
vnoremap <leader>] c[ <C-R>" ]<ESC>
vnoremap <leader>[ c[<C-R>"]<ESC>

" <leader>{ Surround a word with {braces}
nnoremap <leader>} ciw{<C-R>"}<ESC>
nnoremap <leader>{ ciw{<C-R>"}<ESC>
vnoremap <leader>} c{ <C-R>" }<ESC>
vnoremap <leader>{ c{<C-R>"}<ESC>


" w!! to write a file as sudo
cmap w!! w !sudo tee % >/dev/null


nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

let g:rooter_patterns = ['.git', 'Makefile', 'app', 'nvim']

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  let number_of_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  " We should never bdelete a nerd tree
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif

  if number_of_windows_to_this_buffer > 1
    wincmd c
  elseif number_of_buffers > 1
    bdelete!
  else
    quit
  endif
endfunction

" Set specific linters
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'ruby': ['rubocop'],
\}

let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
