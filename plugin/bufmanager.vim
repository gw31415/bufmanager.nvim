let g:bufmanager_last_access = {}
au BufEnter * let g:bufmanager_last_access[nvim_get_current_buf()] = localtime()
