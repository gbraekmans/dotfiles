" Load guard
if ( exists('g:loaded_ctrlp_project') && g:loaded_ctrlp_project )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_project = 1

let s:project_var = {
	\ 'init': 'ctrlp#project#init()',
	\ 'accept': 'ctrlp#project#accept',
	\ 'lname': 'Open a project',
	\ 'sname': 'Projects',
	\ 'type': 'line',
	\ }

" Append s:project_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:project_var)
else
	let g:ctrlp_ext_vars = [s:project_var]
endif

if !exists('g:ctrlp_project_root')
	let g:ctrlp_project_root = '~/Projects'
endif

function! ctrlp#project#init()
	return map(glob(fnameescape(g:ctrlp_project_root).'/{,.}*/', 1, 1), 'fnamemodify(v:val, ":h:t")')
endfunction

function! ctrlp#project#accept(mode, str)
 	call ctrlp#exit()
	exe "cd" g:ctrlp_project_root . '/' .  a:str
	edit README*
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#project#id()
	return s:id
endfunction
