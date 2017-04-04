let no_flake8_maps = 1                       " No remapping of the F7 key
let python_highlight_all = 1                 " Proper .py syntax highlighting

highlight BadWhitespace ctermbg=red guibg=red

function! TrimWhitespace()
	let l:save = winsaveview()
	%s/\s\+$//e
	call winrestview(l:save)
endfun

" PEP-8 config
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal formatoptions=croql
setlocal textwidth=79

" Mappings
nnoremap <buffer> <localleader>f :call flake8#Flake8()<CR>
" Find the previously defined class
nnoremap <buffer> <localleader>c /^\s*class /e+1<CR>
nnoremap <buffer> <localleader>C ?^\s*class ?e+1<CR>
" Find the previously defined function
nnoremap <buffer> <localleader>d /^\s*def /e+1<CR>
nnoremap <buffer> <localleader>D ?^\s*def ?e+1<CR>

" Autocommands
augroup filetype_python
	autocmd!
	autocmd BufWritePost <buffer> call TrimWhitespace()
	autocmd BufWritePre <buffer> call flake8#Flake8()
	autocmd BufRead,BufNewFile <buffer> match BadWhitespace /\s\+$/
augroup END
