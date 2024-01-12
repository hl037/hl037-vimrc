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


function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction


let g:coc_filetypes_enable = ['javascript', 'vue', 'typescript', 'html', 'css', 'scss', 'sass', 'cpp', 'c']

call plug#begin('~/.cache/vim/plugged')

Plug '~/.vim/me/hl037report'

"Plug 'Shougo/vimshell'
Plug 'Shougo/deol.nvim'
Plug 'Shougo/vimproc.vim', {'do' : 'make', 'merged':0}
Plug 'tpope/vim-abolish'
Plug 'kien/ctrlp.vim'
Plug 'vim-scripts/Emmet.vim'
Plug 'scrooloose/nerdtree'
Plug 'unkiwii/vim-nerdtree-sync'
Plug '/usr/share/vim/vimfiles'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/L9'
"Plug 'nvie/vim-pep8'
Plug 'scrooloose/syntastic'
"Plug 'bling/vim-airline'
"Plug 'bling/vim-bufferline'
Plug 'itchyny/lightline.vim'
"Plug 'evidens/vim-twig'
Plug 'Harenome/vim-mipssyntax'
"Plug 'yegappan/grep'
"Plug 'ternjs/tern_for_vim', 'for':'javascript'
"Plug 'Valloric/YouCompleteMe', {'do':function('BuildYCM') , 'for':['javascript', 'vue']}
Plug 'posva/vim-vue'
Plug 'dpelle/vim-Grammalecte'
Plug 'dpelle/vim-LanguageTool'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-lua-ftplugin', {'for': 'lua'}

Plug 'lervag/vimtex', {'for':['latex', 'tex']}
Plug 'wesQ3/vim-windowswap'
Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python', {'for':'javascript'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'for':g:coc_filetypes_enable}
Plug 'puremourning/vimspector', {'for' : ['c', 'cpp', 'python']}
Plug 'peterhoeg/vim-qml', {'for': ['qml']}
Plug 'dbakker/vim-paragraph-motion'
"Plug 'sheerun/vim-polyglot'
Plug 'dylon/vim-antlr'

   """""""""""""""""""""""""""""""""""""
Plug 'davidhalter/jedi-vim', {'for':'python'}
"Plug 'python-mode/python-mode'
"Plugin 'me', {'pinned':1 
"Plug 'hl037/vim-visualHtml', {'merged': 0
"""""""""""""""""""""""""""""""""""""
"Plug 'SirVer/ultisnips'
Plug '~/projects/sources/ultisnips'
"Plug '~/projects/sources/ultisnps-remote_debug'

   """""""""""""""""""""""""""""""""""""
Plug 'godlygeek/tabular'
Plug 'tommcdo/vim-kangaroo'

   """""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'senderle/restoreview'
Plug 'AndrewRadev/sideways.vim'
   """""""""""""""""""""""""""""""""""""
if !has('nvim')
   Plug 'https://github.com/wgurecky/vimSum.git'
   Plug 'roxma/nvim-yarp'
   Plug 'roxma/vim-hug-neovim-rpc'
else
   Plug 'https://github.com/wgurecky/vimSum.git', { 'do' : ':UpdateRemotePlugins' }
endif

Plug 'iloginow/vim-stylus'

Plug 'Yggdroot/indentLine'
Plug '~/.vim/me/maw'
Plug '~/.vim/me/fzf-hl037'
Plug '~/.vim/me/hl037Helpers'

call plug#end()

source ~/.vim/supercontrol.vim

set vdir=~/.vim/view/

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
  if $TERM =~ '256'
    set termguicolors
  "   let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  "   let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  endif
else
  if $TERM =~ '256'
    set termguicolors
  endif
endif

set maxmempattern=100000


" Indent line

let g:indentLine_char_list = ['┃', '┇', '│', '┆', '┊', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷', '╷']
let g:indentLine_color_term=233
let g:indentLine_color_gui='#343434' 

let g:vim_json_conceal = 0

" Sideways
nnoremap <M-h> :SidewaysLeft<cr>
nnoremap <M-l> :SidewaysRight<cr>

let g:kangaroo_no_mappings = 1
nmap <C-Down> <Plug>KangarooPush
nmap <C-Up> <Plug>KangarooPop

let g:jedi#force_py_version = 3
let g:jedi#use_splits_not_buffers = ""
let g:jedi#show_call_signatures = 2
let g:jedi#goto_command = "<leader>f"
let g:jedi#goto_assignments_command = "<leader>a"
let g:jedi#goto_definitions_command = "<leader>g"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
set completeopt=menuone,longest

let g:python_highlight_space_errors = 0



let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit= '~/.vim/UltiSnips'
inoremap <c-x><c-k> <c-x><c-k>

let g:NERDTreeMouseMode = 3
let g:NERDTreeShowHidden = 1


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

"nmap <leader>ff :CtrlP<cr>
nmap <leader>fff :Files g:global_cwd<cr>
nmap <leader>ffb :Buffers<cr>
nmap <leader>fll :Lines<cr>
nmap <leader>flb :BLines<cr>
nmap <leader>flg :Rg<cr>

"nmap <leader>; :Files<cr>
"nmap <leader>: :Buffers<cr>
"nmap <leader>ff :Files<cr>
"nmap <leader>fb :Buffers<cr>
"nmap <leader>fg :BLines<cr>
"nmap <leader>fl :BLines<cr>

nmap <leader>;          <leader>fll
nmap <leader><leader>;  <leader>flg
nmap <leader>: <leader>fff
nmap <leader><leader>: <leader>ffb
nmap <leader>! <leader>ffb


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

inoremap <c-right> <c-i>
inoremap <c-left> <c-o>
nnoremap <c-right> <c-i>
nnoremap <c-left> <c-o>

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

set guicursor=a:blinkon0

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

"let g:languagetool_jar="/usr/share/java/languagetool/languagetool-commandline.jar"
let g:languagetool_cmd='/usr/bin/languagetool'

""""""""""""""""""""""""""""""""""""
"Plugin 'godlygeek/tabular.git'

xnoremap <tab> :Tabularize /


map <c-c> <esc><esc>
smap <c-c> <esc><esc>
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


let g:user_emmet_settings = {
\ 'html': {
\   'empty_element_suffix': ' />',
\   'inline_elements': 'a,li',
\   'block_elements': 'span',
\ },
\ }

""" Lightline conf
"let g:airline_powerline_fonts = 1
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component_function': {
      \   'filename': 'LightLineFilename'
      \ }
      \ }
function! LightLineFilename()
  return expand('%:p:h')
endfunction

set noshowmode
""" END Lightline conf

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
" => Sideways
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <M-l> :SidewaysRight<cr>
nnoremap <M-h> :SidewaysLeft<cr>

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

function! CursorShift(str,...)
    let l:cursor = get(a:, 1, '_|_')
    let l:cursor_len = strlen(l:cursor)
    let l:id = stridx(a:str, l:cursor)
    if l:id < 0
       return a:str
    endif
    return a:str[ : (l:id - 1)] .. a:str[ (l:id + l:cursor_len) : ] .. repeat('<Left>', strlen(a:str[ (l:id + l:cursor_len) : ]))
 endfunction

" function! CmdLine(str,...)
"     exe "menu Foo.Bar :" .. call('CursorShift', [a:str] + a:000)
"     emenu Foo.Bar
"     unmenu Foo
" endfunction
" 
function! CmdLine(str,...)
   let a = call('CursorShift', [a:str] + a:000)
   echom a
   exe "map ÆÆÆ :" .. a
   norm ÆÆÆ
   "unmap ÆÆÆ
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
        call CmdLine("%s" . '/'. l:pattern . '/_|_/g')
    elseif a:direction == 'sub'
        call CmdLine("s" . '/'. l:pattern . '/_|_/g')
    elseif a:direction == 'normal'
        call CmdLine("g" . '/'. l:pattern . '/normal ')
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

fun! Mksession(name)
    let need_tree = g:NERDTree.IsOpen()
    NERDTreeClose
    execute "mksession! " . a:name
    if need_tree
        call writefile(readfile(a:name)+['NERDTree'], a:name)
        NERDTree
    endif
endfun

command! -nargs=1 Mksession call Mksession(<f-args>)

command! DiffHead call <SID>DiffHead()
function! <SID>DiffHead()
   let l:name = expand("%")
   vertical botright new
   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
   silent execute '$read ! git diff -u ' . l:name
   set filetype=diff
endfunction

command! SynGroup call <SID>SynGroup()
function! <SID>SynGroup()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

autocmd BufEnter * silent! lcd %:p:h

let s:ntfind_lock = 0

fun! s:ntfind()
  if s:ntfind_lock || empty(expand('%:p'))
    return
  endif
  if g:NERDTree.IsOpen()
    let s:ntfind_lock = 1
    let l:cur_win = winnr()
    NERDTreeFocus
    let l:nt_win = winnr()
    if l:cur_win != l:nt_win
      wincmd p
      try
        NERDTreeFind
        wincmd p
      catch /.*/
      endtry
    endif
    let s:ntfind_lock = 0
  endif
endfun
autocmd BufEnter * call s:ntfind()

let g:coc_config_home = '~/.vim/coc'
let g:coc_data_home = '~/.vim/coc'

function! s:disable_coc_for_type()
  if index(g:coc_filetypes_enable, &filetype) == -1
    :silent! CocDisable
  else
    :silent! CocEnable
  endif
endfunction

augroup CocGroup
 autocmd!
 autocmd BufNew,BufEnter,BufAdd,BufCreate * call s:disable_coc_for_type()
augroup end

command! GetColor call <SID>GetColor()
function! <SID>GetColor()
  py3 << EOF
import subprocess
from vim_hl037.utils import insert
res = subprocess.run(["kdialog", "--getcolor" ], capture_output=True).stdout.decode('utf8').strip()
insert(res)
EOF
endfunction


command! -nargs=+ Shlex call <SID>Shlex(<q-args>)
function! <SID>Shlex(arg)
  py3 << EOF
import vim
import shlex
from vim_hl037.utils import insert
args = vim.eval("a:arg")
toks = shlex.split(args)
res = f'[{",".join(map(repr, toks))}]'
insert(res)
EOF
endfunction


command! -range -nargs=+ SS <line1>,<line2>call <SID>SubExchange(<f-args>)
function! <SID>SubExchange(w1, w2) range
  execute a:firstline.','.a:lastline.'s/'.a:w1.'/<esc><esc><esc>/eg'
  execute a:firstline.','.a:lastline.'s/'.a:w2.'/'.a:w1.'/eg'
  silent! execute a:firstline.','.a:lastline.'s/<esc><esc><esc>/'.a:w2.'/eg'
endfunction

" function! Ttt()
"    py3 << EOF
" #vim.eval('execute("echom mode()")')
" vim.command('echom mode()')
" vim.feedkeys('
" " vim.eval('execute("stopinsert")')
" " vim.command('stopinsert')
" vim.command('echom mode()')
" EOF
" endfunction
" 
" au InsertChange * :call Ttt()


function SwCase_camel(type)
  call switchcase#switchcase(a:type, 'camel')
endfunction

function SwCase_Camel(type)
  call switchcase#switchcase(a:type, 'Camel')
endfunction

function SwCase_snake(type)
  call switchcase#switchcase(a:type, 'snake')
endfunction

function SwCase_Snake(type)
  call switchcase#switchcase(a:type, 'Snake')
endfunction

function SwCase_SNAKE(type)
  call switchcase#switchcase(a:type, 'SNAKE')
endfunction

map <leader>cc <Cmd>set opfunc=SwCase_camel<CR>g@
map <leader>cC <Cmd>set opfunc=SwCase_Camel<CR>g@
map <leader>c_ <Cmd>set opfunc=SwCase_snake<CR>g@
map <leader>cs <Cmd>set opfunc=SwCase_Snake<CR>g@
map <leader>cS <Cmd>set opfunc=SwCase_SNAKE<CR>g@


"""""""""""""""
" Window zoom
"""""""""""""""
function! ToggleZoom(toggle)
  if exists("t:restore_zoom") && (t:restore_zoom.win != winnr() || a:toggle == v:true)
      exec t:restore_zoom.cmd
      unlet t:restore_zoom
  elseif a:toggle
      let t:restore_zoom = { 'win': winnr(), 'cmd': winrestcmd() }
      vert resize | resize
  endi
endfunction
nnoremap <silent> <c-w>o :call ToggleZoom(v:true)<CR>
augroup restorezoom
    au WinEnter * silent! :call ToggleZoom(v:false)
augroup END
