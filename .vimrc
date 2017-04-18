"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: 
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Version: 
"       5.0 - 29/05/12 15:43:36
"
" Blog_post: 
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Syntax_highlighted:
"       http://amix.dk/vim/vimrc.html
"
" Raw_version: 
"       http://amix.dk/vim/vimrc.txt
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","


set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-abolish'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/Emmet.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'nvie/vim-pep8'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'bling/vim-bufferline'
Plugin 'evidens/vim-twig'
Plugin 'Harenome/vim-mipssyntax'
Plugin 'yegappan/grep'
Plugin 'ternjs/tern_for_vim'

""""""""""""""""""""""""""""""""""""
Plugin 'davidhalter/jedi-vim'

let g:jedi#show_call_signatures = 2
""""""""""""""""""""""""""""""""""""
Plugin 'me', {'pinned':1 }
"Plugin 'hl037/vim-visualHtml'
""""""""""""""""""""""""""""""""""""
Plugin 'SirVer/ultisnips'

let g:UltiSnipsEditSplit = 'vertical'
""""""""""""""""""""""""""""""""""""
Plugin 'godlygeek/tabular.git'
inoremap <c-x><c-k> <c-x><c-k>

let g:UltiSnipsNoMap=1

""""""""""""""""""""""""""""""""""""

call vundle#end()            " required
filetype plugin indent on    " required

"Plugin 'SirVer/ultisnips'

inoremap <silent> <tab> <C-R>=UltiSnips#ExpandSnippetOrJump()<cr>
snoremap <silent> <tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>"
inoremap <silent> <s-tab> <C-R>=UltiSnips#ListSnippets()<cr>"
snoremap <silent> <s-tab> <Esc>:call UltiSnips#ListSnippets()<cr>"

""""""""""""""""""""""""""""""""""""
"Plugin 'godlygeek/tabular.git'

xnoremap <tab> :Tabularize /


map <c-c> <esc>
nnoremap <return> o <bs><esc>



" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

source ~/.vim/maps.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clang_complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let clang_auto_select = 1
let clang_close_preview = 1
let clang_use_library = 1
let clang_complete_macros = 1
let clang_complete_patterns = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom_Maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>i :let my_term = conque_term#open('bash', ['rightb vs'], 0)<CR>

map <leader>e :call ConqueWriteRead(my_term, getline('.'))<CR>
map <leader>r :call my_term.read()<CR>

function ConqueWriteRead(term, str)
   call a:term.writeln(a:str)
   call a:term.read()
endfunction


"let g:user_emmet_settings = {
"         \  'indentation' : '   ',
"         \  'perl' : {
"         \    'aliases' : {
"         \      'req' : 'require '
"         \    },
"         \    'snippets' : {
"         \      'use' : "use strict\nuse warnings\n\n",
"         \      'warn' : "warn \"|\";",
"         D
"         \    }
"         \  }
"         \}

let g:airline_powerline_fonts = 1

let g:NERDTreeWinPos = "left"
map <leader>T :NERDTree<CR>

let g:user_emmet_expandabbr_key = '<c-e>e'
let g:user_emmet_leader_key  = '<c-e>'
let g:user_emmet_next_key = '<c-l>'
let g:user_emmet_prev_key = '<c-h>'

"let g:use_emmet_complete_tag = 1
"imap <c-e>e <plug>(EmmetExpandAbbr)
"nmap <c-e> <Plug>EmmetExpandWord
"nmap <c-e> <Plug>EmmetBalanceTagInward
"nmap <c-e> <Plug>EmmetBalanceTagOutward
"nmap <c-e>n <Plug>(EmmetMoveNext)
"nmap <c-e>p <Plug>(EmmetMovePrev)
"nmap <c-e> <Plug>EmmetImageSize
"nmap <c-e> <Plug>EmmetToggleComment
"nmap <c-e> <Plug>EmmetSplitJoinTag
"nmap <c-e> <Plug>EmmetRemoveTag
"nmap <c-e> <Plug>EmmetAnchorizeURL
"nmap <c-e> <Plug>EmmetAnchorizeSummary
"nmap <c-e> <Plug>EmmetMergeLines
"nmap <c-e> <Plug>EmmetCodePretty


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => SuperTab configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Leader>tt :CommandT<CR>
nnoremap <silent> <Leader>bt :CommandTBuffer<CR>

map <leader>bn :bn<CR>
map <leader>bp :bp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TaskList onfiguration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <silent> <Leader>bt <Plug>TaskList

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => SuperTab configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:SuperTabMappingForward = '<c-space>'
"let g:SuperTabMappingBackward = '<c-s-space>'



au BufRead,BufNewFile *.md set filetype=markdown


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <Nul> <c-x><c-o>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => visualHtml
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ut=4000

let g:visualHtml#live = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" to translate my help files in Markdown
command! Help2Md call <SID>Help2Md()
function <SID>Help2Md()
   %s/^ \*.*\*\s*\n//
   %s/^ \*.*\*\s*/    /
   %s/^ \a/   \0/
   %s/\s*\*.*\*\s*//g
   %s/\.\.\.\..*//g
   %s/=\+\_s\(\d\+\.\)\s*\(.*\)\_s-\+/# \1 \2/g
   exec 'normal gg2dd/====' . "\<CR>" . 'kVgg:normal 4I ' . "\<CR>" . ",\<CR>"
   '<,'>s/\~$//
   exec "normal /#\<CR>,\<CR>"
   .,$s/\(.*\)\_s------*/## \1/
endfunction

