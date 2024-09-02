set nocompatible
set path+=**
set wildmenu
set wildmode=longest:full,full
set number	" Show line numbers
" set linebreak	" Break lines at word (requires Wrap lines)
set nowrap
" set showbreak=+++	" Wrap-broken line prefix
" set textwidth=100	" Line wrap (number of cols)
set showmatch	" Highlight matching brace
set nospell	" Enable spell-checking
set visualbell	" Use visual bell (no beeping)
 
set hlsearch	" Highlight all search results
set nohlsearch  " No hilight
set smartcase	" Enable smart-case search
set ignorecase	" Always case-insensitive
set incsearch	" Searches for strings incrementally
 
set autoindent	" Auto-indent new lines
set expandtab	" Use spaces instead of tabs
set shiftwidth=4	" Number of auto-indent spaces
set smartindent	" Enable smart-indent
set smarttab	" Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
set mouse=a 
command! MakeTags !ctags -R .
" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" Advanced
set ruler	" Show row and column ruler information
 
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour
" call plug#begin('~/.vim/plugged')
" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


set foldmethod=manual
set nofoldenable
" Make sure you use single quotes

" Plug 'morhetz/gruvbox'
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-repeat'
" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'machakann/vim-sandwich'
" Plug 'lervag/vimtex'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'jiangmiao/autopairs'

" Initialize plugin system
" call plug#end()
" let g:coc_disable_startup_warning = 1
" syntax off

