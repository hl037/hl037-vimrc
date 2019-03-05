if exists("b:current_syntax")
    finish
endif

syn case ignore
syn keyword _037RTodo todo
syn case match

syn match _037RTitle /\v^\s*(\d|\w|\.)+\).*$/
syn match _037RWarning /\v^\s*\zs!.*$/
syn match _037RImpWarning /\v^\s*\zs!\s*!.*$/
syn match _037RImportant /\v^\s*\zs\*.*$/
syn match _037RQuestion /\v^\s*\zs\?.*$/
syn match _037RImpQuestion /\v^\s*\zs!\?.*$/
syn match _037RResponse /\v^\s*\zs-\>.*$/
syn match _037RImpResponse /\v^\s*\zs!\s?-\>.*$/
syn region _037RCode start='`' end='`' 


hi link _037RTodo Todo
hi link _037RTitle Title
hi link _037RWarning Warning
hi link _037RImpWarning Warning
hi link _037RImportant Important
hi link _037RQuestion Question
hi link _037RImpQuestion Question
hi link _037RResponse Response
hi link _037RImpResponse Response
hi link _037RCode String

let b:current_syntax = "hl037report"
