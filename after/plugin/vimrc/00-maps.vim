
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
" /!\ SEE AFTER/PLUGIN/VIMRC/MAPS.VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
"


let mapleader = ","
let g:mapleader = ","


map <c-c> <esc>
imap <c-c> <esc>
vmap <c-c> <esc>
smap <c-c> <esc>
tnoremap <m-c> <c-\><c-n>
nnoremap <return> o<space><bs><esc>

" Fast saving
nmap <leader>w :w!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Set number active
set nu

" Show command typing
set showcmd

" Set mouse on
set mouse=a
" try
"    set ttymouse=sgr
" catch
"    set ttymouse=xterm2
" endtry
   
function! ToggleMouse()
   if &mouse == 'a'
      set mouse=
      echo "Mouse usage disabled"
   else
      set mouse=a
      echo "Mouse usage enabled"
   endif
endfunction
nnoremap <leader>m :call ToggleMouse()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

set t_Co=256

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac
colorscheme hl037

	

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
if has('nvim')
  set swapfile
  set directory=$HOME/.vim/swp//
else
  set noswapfile
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 3 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
vnoremap <silent> <leader>* :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
noremap j gj
noremap k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
nn <space> /

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
nn <C-j> <C-W>j
nn <C-k> <C-W>k
nn <C-h> <C-W>h
nn <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>
map <leader>bc :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>wn :tabnew<cr>
map <leader>wo :tabonly<cr>
map <leader>wc :tabclose<cr>
map <leader>wm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>we :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
" map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z


" Quickly add a ';' at line and with Ctrl + ;
imap <special> <c-;> <c-o>$;
nmap <special> <c-;> A;<esc>
vmap <special> <c-;> A;<esc>


 
" if has("mac") || has("macunix")
"   nmap <D-j> <M-j>
"   nmap <D-k> <M-k>
"   vmap <D-j> <M-j>
"   vmap <D-k> <M-k>
" endif
" 
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
"func! DeleteTrailingWS()
"  exe "normal mz"
"  %s/\s\+$//ge
"  exe "normal `z"
"endfunc
"autocmd BufWrite *.py :call DeleteTrailingWS()
"autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader><leader>r :call VisualSelection('replace')<CR>
vnoremap <silent> <leader><leader>s :call VisualSelection('sub')<CR>
vnoremap <silent> <leader><leader>n :call VisualSelection('normal')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
" map <leader>cc :botright cope<cr>
" map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>N :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
" noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
"map <leader>pp :setlocal paste!<cr>

map <leader>bb :e #<cr>
map <leader>bw :Bclose <cr>

if &diff
   nnoremap <C-j> ]c
   nnoremap <C-k> [c
   nnoremap <C-i> do
   nnoremap <C-o> dp
endif
   
" The expected behaviour
nmap Y y$

nmap <Leader>o :!open "%"<cr><cr>

"map <C-LeftMouse> <LeftMouse><leader>g

" no timeout for ambiguous maps
"set timeoutlen=0
"set nottimeout
"set ttimeoutlen=0

" Quick copy paste all file
nmap <leader><leader>y gg"+yG<c-o>
nmap <leader><leader>p ggdG"+PGdd
"nmap <leader><leader>mr :!make run<cr>
nmap <leader><leader>mr :!konsole -e bash -c "make run ; read"<cr>
"nmap <leader><leader>m<space> :!make<space>
function! TTTKonsoleMake()
  call CmdLine('!konsole -e bash -c "make _|_ ; read"')
endfunction
nmap <leader><leader>m<space> :call TTTKonsoleMake()<cr>
"nmap <leader><leader>m<cr> :!make<cr>
nmap <leader><leader>mr :!konsole -e bash -c "make; read"<cr>

nmap <Leader><Leader>e <Plug>VimspectorBalloonEval
xmap <Leader><Leader>e <Plug>VimspectorBalloonEval

map <F4>         <Plug>VimspectorStop
map <leader><F4> :VimspectorReset<cr>
map <F5>         <Plug>VimspectorRestart
map <silent> <leader><F5>         :call vimspector#Launch()<cr>
map <F6>         <Plug>VimspectorPause
map <F7>         <Plug>VimspectorAddFunctionBreakpoint
map <F8>         <Plug>VimspectorToggleBreakpoint
map <leader><F8> <Plug>VimspectorToggleConditionalBreakpoint
map <F9>         <Plug>VimspectorContinue
map <leader><F9> <Plug>VimspectorRunToCursor
map <F10>        <Plug>VimspectorStepOver
map <F11>        <Plug>VimspectorStepInto
map <F12>        <Plug>VimspectorStepOut
map -    <Plug>VimspectorUpFrame
map +    <Plug>VimspectorDownFrame


map <silent> <leader>sw :Mksession _me_vimsession.vim<cr>
map <silent> <leader>ee :bufdo e!<cr>

map <leader>a :VisMath()<Left>

