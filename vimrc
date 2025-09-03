color default
" General Settings
set number
set noswapfile
set background=dark
set cursorline
set spell
set is
set ruler

" Indentation and Formatting
set expandtab
set tabstop=4
set shiftwidth=4
set ai

" Search Behavior
set ignorecase
set smartcase
set wildmenu
set wildignore=*.exe,*.dll,*.pdb

" GUI Options
set guioptions-=m
set guioptions-=T
set guioptions-=r

" Syntax and Filetype Support
syntax on
filetype plugin indent on

" Leader Key
let mapleader=' '

" Remove whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Plugin Manager Installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install ripgrep
if empty(glob('/usr/bin/rg')) && empty(glob('/usr/local/bin/rg'))
  silent execute 'sudo apt-get install ripgrep'
endif

" Plugins
call plug#begin('~/vimplugins')
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

" Auto-completion Mappings
imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" LSP Configuration
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gi <plug>(lsp-definition)
    nmap <buffer> gd <plug>(lsp-declaration)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gl <plug>(lsp-document-diagnostics)
    nmap <buffer> <f2> <plug>(lsp-rename)
    nmap <buffer> <f3> <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    let g:asyncomplete_auto_popup_delay = 300  " Delay in milliseconds
augroup END

" FZF Keybindings
nnoremap <silent> <leader>/ :Rg<CR>
nnoremap <silent> <leader><space> :Files<CR>

" Additional Features
set gp=git\ grep\ -n
packadd! matchit

nnoremap <C-k> :silent !clang-format -i %<CR>:e<CR>

