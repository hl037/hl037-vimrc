"$bf_lye"eye^[dbea() { return ^[p"epA }^[Iinline ^[^
"$b"zyedt_l"eye^"ePa(^[f;i) { ^["zpa = _^["epA }^[^iinline void set^[l^[~^
"$b"zyedt_i& ^[f_l"eye^"ePa(const ^[f;i) { ^["zpa = _^["epA }^[^iinline void set^[l~^

command! VarGetter call <SID>VarGetter()
function <SID>VarGetter()
   exec 'normal $bf_l"eyedbea() const { return ' . "\<ESC>" . 'p"epA }' . "\<ESC>" . '^iinline ' . "\<ESC>" . '^'
endfunction

command! VarGetterConstRef call <SID>VarGetterConstRef()
function <SID>VarGetterConstRef()
   exec 'normal $bf_l"eyedbi& ' . "\<ESC>" . 'ea() const { return ' . "\<ESC>" . 'p"epA }' . "\<ESC>" . '^iinline const ' . "\<ESC>" . '^'
endfunction

command! VarSetter call <SID>VarSetter()
function <SID>VarSetter()
   exec 'normal $b"zyedt_l"eye^"ePa(' . "\<ESC>" . 'f;i) { ' . "\<ESC>" . '"zpa = _' . "\<ESC>" . '"epA }' . "\<ESC>" . '^iinline void set' . "\<ESC>" . 'l' . "\<ESC>" . '~^'
endfunction

command! VarSetterConstRef call <SID>VarSetterConstRef()
function <SID>VarSetterConstRef()
   exec 'normal $b"zyedt_i& ' . "\<ESC>" . 'f_l"eye^"ePa(const ' . "\<ESC>" . 'f;i) { ' . "\<ESC>" . '"zpa = _' . "\<ESC>" . '"epA }' . "\<ESC>" . '^iinline void set' . "\<ESC>" . 'l~^'
endfunction

nnoremap <leader>cg :VarGetterConstRef<CR>
vnoremap <leader>cg :norm <leader>cg<CR>

nnoremap <leader>cs :VarSetterConstRef<CR>
vnoremap <leader>cs :norm <leader>cs<CR>
