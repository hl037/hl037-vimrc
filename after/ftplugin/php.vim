set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<C-g>u<CR>'
inoremap <expr> <Nul> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


