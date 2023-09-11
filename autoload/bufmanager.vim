fu! s:get_order(bufnr)
	if has_key(g:bufmanager_last_access, a:bufnr)
		return g:bufmanager_last_access[a:bufnr]
	else
		return 0
	en
endfu

fu! s:list_bufs()
	return nvim_list_bufs()
		\->filter("buflisted(v:val)")
		\->filter("nvim_buf_get_name(v:val) != ''")
		\->filter("nvim_buf_get_name(v:val) != ''")
		\->filter({i, v -> v != s:current_buf})
		\->sort({a, b -> s:get_order(a) < s:get_order(b)})
endfu

fu! bufmanager#bdelete_opfunc(type = '') abort
	if a:type == ''
		set operatorfunc=bufmanager#bdelete_opfunc
		return 'g@'
	endif
	let bufs = range(line("'["), line("']"))->map("fzyselect#getitem(v:val)[0]")
	for buf in bufs
		cal nvim_buf_delete(buf, {})
	endfor
	let s:bufs = s:list_bufs()
	sil! cal fzyselect#refresh(s:bufs)
	if len(s:bufs) == 0 | clo | endi
endfu

fu! s:format(bufnr)
	let path = nvim_buf_get_name(a:bufnr)
	let current_dir = fnamemodify('.', ':p')
    let absolute_path = fnamemodify(path, ':p')
	if stridx(absolute_path, current_dir) == 0
		retu fnamemodify(path, ':.')
    el
		retu absolute_path
    endi
endfu

fu! bufmanager#open() abort
	let current_win = nvim_get_current_win()
	let s:current_buf = nvim_get_current_buf()
	let s:bufs = s:list_bufs()
	au FileType fzyselect ++once nn <buffer><expr> <Plug>(bufmanager-bdelete) bufmanager#bdelete_opfunc()
	au FileType fzyselect ++once xn <buffer><expr> <Plug>(bufmanager-bdelete) bufmanager#bdelete_opfunc()
	cal fzyselect#start(s:bufs, #{
				\ format_item: {n -> s:format(n)},
				\ prompt: 'bufmanager'
				\ }, { buf -> buf ? nvim_win_set_buf(current_win, buf) : v:null })
endfu
