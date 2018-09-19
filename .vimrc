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

let mapleader = ","
let g:mapleader = ","

set encoding=utf-8

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein/')
   call dein#begin('~/.vim/dein/')

   " Let dein manage dein
   " Required:
   call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')

   " You can specify revision/branch/tag.
   call dein#add('Shougo/vimshell', {'merged':0})
   call dein#add('Shougo/vimproc.vim', {'build' : 'make', 'merged':0})
   call dein#add('tpope/vim-abolish', {'merged':0})
   call dein#add('kien/ctrlp.vim', {'merged':0})
   call dein#add('vim-scripts/Emmet.vim', {'merged':0})
   call dein#add('scrooloose/nerdtree', {'merged':0})
   call dein#add('unkiwii/vim-nerdtree-sync', {'merged':0})
   call dein#add('/usr/share/vim/vimfiles', {'merged':0})
   call dein#add('junegunn/fzf.vim', {'merged':0})
   call dein#add('vim-scripts/L9', {'merged':0})
   "call dein#add('nvie/vim-pep8', {'merged':0})
   call dein#add('scrooloose/syntastic', {'merged':0})
   call dein#add('bling/vim-airline', {'merged':0})
   call dein#add('bling/vim-bufferline', {'merged':0})
   "call dein#add('evidens/vim-twig', {'merged':0})
   call dein#add('Harenome/vim-mipssyntax', {'merged':0})
   call dein#add('yegappan/grep', {'merged':0})
   "call dein#add('ternjs/tern_for_vim', {'merged':0, 'on_ft':'javascript'})
   call dein#add('Valloric/YouCompleteMe', {'merged':0, 'on_ft':['javascript', 'vue']})
   call dein#add('posva/vim-vue', {'merged':0})
   call dein#add('dpelle/vim-Grammalecte', {'merged':0})
   call dein#add('xolox/vim-misc', {'merged':0})
   call dein#add('xolox/vim-lua-ftplugin', {'merged':0, 'on_ft': 'lua'})

   call dein#add('lervag/vimtex', {'merged':0, 'on_ft':['latex', 'tex']})
   call dein#add('wesQ3/vim-windowswap', {'merged':0})
   call dein#add('kana/vim-textobj-user', {'merged':0})
   call dein#add('bps/vim-textobj-python', {'merged':0, 'on_ft':'javascript'})
   call dein#add('dbakker/vim-paragraph-motion', {'merged':0})

   """""""""""""""""""""""""""""""""""""
   call dein#add('davidhalter/jedi-vim', {'merged':0, 'on_ft':'python'})
   "call dein#add('python-mode/python-mode', {'merged':0})
   "

   """""""""""""""""""""""""""""""""""""
   "Plugin 'me', {'pinned':1 }
   call dein#add( 'hl037/vim-visualHtml', {'merged': 0})
   """""""""""""""""""""""""""""""""""""
   call dein#add('SirVer/ultisnips', {'merged':0})

   """""""""""""""""""""""""""""""""""""
   call dein#add('godlygeek/tabular.git', {'merged':0})

   """""""""""""""""""""""""""""""""""""

   " Required:
   call dein#end()
   call dein#save_state()
endif

source ~/.vim/supercontrol.vim

" Required:
filetype plugin indent on
syntax enable

if !has('nvim')
   set ttymouse=sgr
   set clipboard+=unnamedplus
   map <esc>OA <up>
   map <esc>OA <Up>
   map <esc>OB <down>
   map <esc>OB <Down>
   map <esc>OC <right>
   map <esc>OC <Right>
   map <esc>OD <left>
   map <esc>OD <Left>
   map <esc>[1;5A <c-up>
   map <esc>[1;5A <c-Up>
   map <esc>[1;5B <c-down>
   map <esc>[1;5B <c-Down>
   map <esc>[1;5C <c-right>
   map <esc>[1;5C <c-Right>
   map <esc>[1;5D <c-left>
   map <esc>[1;5D <c-Left>
endif

let g:jedi#force_py_version = 3
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#show_call_signatures = 2
let g:jedi#goto_command = "<leader>f"
let g:jedi#goto_assignments_command = "<leader>a"
let g:jedi#goto_definitions_command = "<leader>g"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"



let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
inoremap <c-x><c-k> <c-x><c-k>

let g:NERDTreeMouseMode = 3

" Start autocompletion after 4 chars
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_enable_diagnostic_highlighting = 0

let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion = ['<Down>', '<C-Space>']
let g:ycm_key_list_stop_completion = ['<Return>']
let g:ycm_filetype_whitelist = { 'javascript': 1, 'vue' : 1}
let g:ycm_filetype_blacklist = { 'python': 1, 'php' : 1 }
" Don't show YCM's preview window
"set completeopt-=preview
"let g:ycm_add_preview_to_completeopt = 0

let g:ctrlp_map = ''
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_buffer_func = { 'enter': 'CtrlP_HL_enter', }

nmap <leader>ff :CtrlP<cr>
nmap <leader>fb :CtrlPBuffer<cr>
nmap <leader>fg :Lines<cr>
nmap <leader>fl :BLines<cr>

"nmap <leader>; :Files<cr>
"nmap <leader>: :Buffers<cr>
"nmap <leader>ff :Files<cr>
"nmap <leader>fb :Buffers<cr>
"nmap <leader>fg :BLines<cr>
"nmap <leader>fl :BLines<cr>

nmap <leader>; <leader>ff
nmap <leader>: <leader>fb
nmap <leader>! <leader>fg

let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

imap <c-right> <c-i>
imap <c-left> <c-o>
nmap <c-right> <c-i>
nmap <c-left> <c-o>

let g:pymode_trim_whitespaces = 0
let g:pymode_options = 0
let g:pymode_indent = 0

let g:pymode_folding = 0
let g:pymode_motion = 1


let g:syntastic_python_checkers = ['python']
let g:pymode_lint_ignore = ["E111", "E114", "W293","E2", "E3", "W3", "W5", "E74", "E722", "E501"]
let g:pymode_lint_checkers = ['pylint', 'pep8', 'mccabe']
let g:pymode_lint = 0

let g:pymode_doc = 1
let g:pymode_doc_bind = '<leader>h'
let g:pymode_run = 1
let g:pymode_run_bind = '!r'
let g:pymode_rope = 1

let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_goto_definition_bind = '<F2>'
let g:pymode_rope_goto_definition_cmd = 'vnew'
let g:pymode_rope_rename_bind = '<leader>rr'
let g:pymode_rope_rename_module_bind = '<leader>rm'
let g:pymode_rope_organize_imports_bind = '<leader>ro'
let g:pymode_rope_autoimport_bind = '<leader>ri'
let g:pymode_rope_extract_method_bind = ''
let g:pymode_rope_extract_variable_bind = ''
let g:pymode_rope_use_function_bind = ''

let g:pymode_rope_move_bind = ',rv'
let g:pymode_rope_change_signature_bind = ''


let g:pymode_syntax = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_syntax_all = 1


" If you want to install not installed plugins on startup.
"if dein#check_install()
"   call dein#install()
"endif

"End dein Scripts-------------------------


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file

let g:lua_complete_omni = 1

set guicursor=a:blinkon1

"Plugin 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsListSnippets = "<s-tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"

"inoremap <silent> <tab> <C-R>=UltiSnips#ExpandSnippetOrJump()<cr>
"snoremap <silent> <tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>"
"inoremap <silent> <s-tab> <C-R>=UltiSnips#ListSnippets()<cr>"
"snoremap <silent> <s-tab> <Esc>:call UltiSnips#ListSnippets()<cr>"


""""""""""""""""""""""""""""""""""""
"Plugin 'grammalecte'
let g:grammalecte_cli_py = "~/.vim/g/grammalecte-cli.py"
let g:grammalecte_disable_rules = "apostrophe_typographique apostrophe_typographique_après_t espaces_début_ligne espaces_milieu_ligne typo_points_suspension1 nbsp_après_chevrons_ouvrants nbsp_avant_chevrons_fermants1 typo_tiret_incise typo_guillemets_typographiques_doubles_ouvrants typo_guillemets_typographiques_doubles_fermants typo_tiret_début_ligne esp_milieu_ligne typo_parenthese_ouvrante_collée typo_espace_manquant_après1 typo_ponctuation_superflue3 typo_espace_avant_signe_fermant typo_espace_après_signe_ouvrant esp_début_ligne typo_guillemets_typographiques_simples_ouvrants typo_guillemets_typographiques_simples_fermants typo_points_suspension3 nbsp_avant_deux_points unit_nbsp_avant_unités1"

""""""""""""""""""""""""""""""""""""
"Plugin 'godlygeek/tabular.git'

xnoremap <tab> :Tabularize /


map <c-c> <esc><esc>
imap <c-c> <esc><esc>
nnoremap <return> o <bs><esc>



" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Windowswap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <c-w>y :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <c-w>p :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> <c-w>r :call WindowSwap#EasyWindowSwap()<CR><Paste>


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

map <leader>y "+y
map <leader>p "+p
map <leader>d "+d

map <leader>ti :let my_term = conque_term#open('bash', ['rightb vs'], 0)<CR>

map <leader>te :call ConqueWriteRead(my_term, getline('.'))<CR>
map <leader>tr :call my_term.read()<CR>

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
map <leader>tt :NERDTree<CR>

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

"nnoremap <silent> <Leader>tt :CommandT<CR>
"nnoremap <silent> <Leader>bt :CommandTBuffer<CR>

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

let g:visualHtml#active = 0
let g:visualHtml#live = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! DiffOri call DiffOri()

function! DiffOri()
  :w! /tmp/working_copy
  exec "!diff /tmp/working_copy %"
endfunction

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

