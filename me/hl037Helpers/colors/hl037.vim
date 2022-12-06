
set background=dark


"these lines are suggested to be at the top of every colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif

"Load the 'base' colorscheme - the one you want to alter
runtime colors/desert.vim

"Override the name of the base colorscheme with the name of this custom one
let g:colors_name = "hl037"



" hi Normal	guifg=White guibg=grey20
" 
" " highlight groups
" hi Cursor	guibg=khaki guifg=slategrey
" "hi CursorIM
" "hi Directory
" "hi DiffAdd
" "hi DiffChange
" "hi DiffDelete
" "hi DiffText
" "hi ErrorMsg
" hi VertSplit	guibg=#c2bfa5 guifg=grey50 gui=none
" hi Folded	guibg=grey30 guifg=gold
" hi FoldColumn	guibg=grey30 guifg=tan
" hi IncSearch	guifg=slategrey guibg=khaki
" "hi LineNr
" hi ModeMsg	guifg=goldenrod
" hi MoreMsg	guifg=SeaGreen
" hi NonText	guifg=LightBlue guibg=grey30
" hi Question	guifg=springgreen
" hi Search	guibg=peru guifg=wheat
" hi SpecialKey	guifg=yellowgreen
" hi StatusLine	guibg=#c2bfa5 guifg=black gui=none
" hi StatusLineNC	guibg=#c2bfa5 guifg=grey50 gui=none
" hi Title	guifg=indianred
" hi Visual	gui=none guifg=khaki guibg=olivedrab
" hi WarningMsg	guifg=salmon
" "hi WildMenu
" "hi Menu
" "hi Scrollbar
" "hi Tooltip
" hi Comment	guifg=SkyBlue
" hi Constant	guifg=#ffa0a0
" hi Identifier	guifg=palegreen
" hi Statement	guifg=khaki
" hi PreProc	guifg=indianred
" hi Type		guifg=darkkhaki
" hi Special	guifg=navajowhite
" "hi Underlined
" hi Ignore	guifg=grey40
" "hi Error
" hi Todo		guifg=orangered guibg=yellow2


" gui colors
hi Normal guifg=#AAAAAA guibg=Black
hi MatchParen guibg=#444444 guifg=#d7ff00
hi NonText	guifg=darkblue guibg=#0A0A0A



hi SpecialKey	guifg=darkgreen
hi Directory	guifg=darkcyan
hi ErrorMsg	guifg=#8D8D8D guibg=#C00000
hi IncSearch	guifg=#ffff00 guibg=#00FF00
hi IncSearch	guifg=black guibg=#8787ff
hi Search	guifg=black guibg=#8787ff
hi MoreMsg	guifg=darkgreen
hi ModeMsg	guifg=brown
hi LineNr	guifg=#C0C000
hi Question	guifg=green
hi StatusLine	gui=reverse
hi StatusLineNC gui=reverse
hi VertSplit	gui=reverse
hi Title	guifg=#AE00FF
hi Visual	gui=reverse
hi WarningMsg	guifg=#C00000
hi WildMenu	guifg=#040404 guibg=#C0C000
hi Folded	guifg=darkgrey guibg=NONE
hi FoldColumn	guifg=darkgrey guibg=NONE
hi DiffAdd	guibg=#1818B2
hi DiffChange	guibg=#AE00FF
hi DiffDelete	guifg=#5454FF guibg=#18B2B2
hi DiffText	guibg=#C00000
hi Comment	guifg=darkcyan
hi Constant	guifg=#af5f00
"hi Constant	guifg=#cf6e00
hi Special	guifg=#AE00FF
hi Identifier	guifg=#1ddddd
hi Statement	guifg=#C0C000
hi PreProc	guifg=#AE00FF
hi Type		guifg=#008000
hi Underlined	guifg=#AE00FF
hi Error	guifg=#8D8D8D guibg=#C00000

" color terminal definitions
hi Normal ctermfg=8 ctermbg=Black
hi MatchParen ctermbg=238 ctermfg=190

hi SpecialKey	ctermfg=darkgreen guifg= guibg=
hi NonText	cterm=bold ctermfg=darkblue
hi Directory	ctermfg=darkcyan
hi ErrorMsg	cterm=bold ctermfg=7 ctermbg=1
hi IncSearch	cterm=NONE ctermfg=yellow ctermbg=green
hi Search 	ctermfg=black ctermbg=105
hi MoreMsg	ctermfg=darkgreen
hi ModeMsg	cterm=NONE ctermfg=brown
hi LineNr	ctermfg=3
hi Question	ctermfg=green
hi StatusLine	cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit	cterm=reverse
hi Title	ctermfg=5
hi Visual	cterm=reverse
hi WarningMsg	ctermfg=1
hi WildMenu	ctermfg=0 ctermbg=3
hi Folded	ctermfg=darkgrey ctermbg=NONE
hi FoldColumn	ctermfg=darkgrey ctermbg=NONE
hi DiffAdd	ctermbg=4
hi DiffChange	ctermbg=5
hi DiffDelete	cterm=bold ctermfg=4 ctermbg=6
hi DiffText	cterm=bold ctermbg=1
hi Comment	ctermfg=darkcyan
hi Constant	ctermfg=brown
hi Special	ctermfg=5
hi Identifier	ctermfg=6
hi Statement	ctermfg=3
hi PreProc	ctermfg=5
hi Type		ctermfg=2
hi Underlined	cterm=underline ctermfg=5
hi Ignore	cterm=bold ctermfg=7
hi Ignore	ctermfg=darkgrey
hi Error	cterm=bold ctermfg=7 ctermbg=1


" Additionnals


" gui
hi DiffAdd guibg=#005f00
hi DiffDelete guibg=#5f0000
hi DiffChange guibg=#00005f
hi DiffText guibg=bg
hi diffAdded guifg=#008000
hi diffNewFile guifg=#008000
hi diffRemoved guifg=#c00000
hi diffOldFile guifg=#c00000
hi diffChange guifg=#00005f
hi diffLine guifg=#1ddddd
hi diffSubName guifg=#ffff00
hi diffText guibg=bg
hi cursorline guibg=darkblue guifg=white  
hi Pmenu guibg=#00005f guifg=grey
hi PmenuSel guibg=#0000ff  guifg=#d0d0d0

hi TabLine cterm=underline ctermfg=15 ctermbg=242 gui=underline guibg=#AAAAAA guifg=#000000

" term
hi DiffAdd cterm=none ctermbg=22
hi DiffDelete cterm=none ctermbg=52
hi DiffChange cterm=none ctermbg=17
hi DiffText cterm=none ctermbg=bg
hi cursorline cterm=None ctermbg=darkblue ctermfg=white
hi Pmenu ctermbg=017 ctermfg=grey
hi PmenuSel ctermbg=021 ctermfg=252


