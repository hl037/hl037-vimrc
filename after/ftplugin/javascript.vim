if index(get(g:, 'config_flavor', []), "js4") >= 0
  set shiftwidth=4
  set tabstop=4
else
  set shiftwidth=2
  set tabstop=2
endif
set expandtab

