                " " " " " " " " " " " " " "
                " Author: Charlie Davis   "
                " Last Edited: 2024-03-05 "
                "                         "
                " " " " " " " " " " " " " "
	
"========================================================
"                  ====================
"                ~ = General Settings = ~
"                  ====================

set nocompatible	       " Don't pretend to be vi

if has("vms")
    set nobackup               " Do not keep a backup file, use versions instead
else
    set backup                 " Keep a backup file
endif

set backupdir=~/.vim/backup    " Send backup files to .vim/backup
set noswapfile                 " Disable saving swap files
set history=200                " Keep 50 lines of command line history
set ruler                      " Show the cursor position all the time
set showcmd                    " Display incomplete commands
set incsearch                  " Do incremental searching
set ignorecase                 " Ignore case in searches--
set smartcase                  " unless you enter a capital letter
set wildmenu		       " Display wild menu
set ls=2                       " Shows statusline always
set nu                         " Show line numbers
set scrolloff=5                " Start scrolling when 5 lines from margins
set timeout ttimeoutlen=100	   " Time out length at 100ms

" use gf to open files under cursor, search in separate directories
let &path.="src/include,/usr/include/AL,"

"========================================================


"========================================================
"                  ====================
"                ~ =    Appearance    = ~
"                  ====================
						
" Switch syntax highlighting on when the terminal has colors
" Also switch on highlighting the last used search pattern
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

"========================================================


"========================================================
"                  ====================
"                ~ =    Autocommand   = ~
"                  ====================

" Only do this part if compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  set omnifunc=syntaxcomplete#Complete
  set completeopt-=preview

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim), for a commit or rebase message
  " (likely a different one than last time), and when using xxd(1) to filter
  " and edit binary files (it transforms input files back and forth, causing
  " them to have dual nature, so to speak)
  autocmd BufReadPost *
			  \ let line = line("'\"")
			  \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
			  \      && index(['xxd', 'gitrebase'], &filetype) == -1
			  \ |   execute "normal! g`\""
			  \ | endif

  augroup END

  " change status line color based on mode
  hi statusline term=reverse ctermfg=0 ctermbg=2
  au InsertEnter * hi statusline term=reverse ctermbg=4 gui=undercurl guisp=Magenta
  au InsertLeave * hi statusline term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")

"========================================================


"========================================================
"                  ====================
"                ~ =    Whitespace    = ~
"                  ====================


set tabstop=4                  " tab character is 4 columns
set softtabstop=4              " tab key indents 4
set shiftwidth=4               " ==, <<, and >> indent 4 columns
set noexpandtab                " tab characters turn into spaces



"===== Change Whitespace Settings Based on Filetype =====

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType lilypond setlocal ts=2 sts=2 sw=2
  autocmd FileType markdown setlocal complete+=kspell spell tw=75

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml

endif



"=============== Strip Trailing Whitespace ==============

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

"========================================================


"========================================================
"                  ====================
"                ~ =   Key Mappings   = ~
"                  ====================


"======================= General ========================

" Don't use Ex mode, use Q for quick macro
map Q @q

" Y to yank to end of line. use yy for yanking whole line
map Y y$

" accidentally entering capital q won't hurt anyone
cnoreabbrev Q q

" press space to center screen on cursor
nmap <space> zz
" searching will keep cursor on middle of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

" <Leader>cd to move to file's working directory
nnoremap <Leader>cd :lcd %:h<CR>
"========================================================


"==================== Function Keys =====================

" delete whitespace at eols with F9
nnoremap <silent> <F9> :call <SID>StripTrailingWhitespaces()<CR>

" F10 will search help for the word under the cursor
nnoremap <F10> :help <C-r><C-w><CR>

"========================================================


"====================== C Stuff =========================

" Open definition in split with <Leader>/
nnoremap <Leader>/ :vsp<CR> :exec("tag ".expand("<cword>"))<CR>


"========================================================


"========================= Misc =========================

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" hide search hl with ctrl+l
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

"========================================================
