let no_flake8_maps = 1                       " No remapping of the F7 key
let python_highlight_all = 1                 " Proper .py syntax highlighting

" PEP-8 config
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal autoindent
setlocal formatoptions=croql
setlocal textwidth=79

" Mappings
nnoremap <buffer> <localleader>f :call flake8#Flake8()<CR>

" Autocommands
augroup filetype_python
	autocmd!
	autocmd BufWritePost * call flake8#Flake8()
	autocmd BufRead,BufNewFile * match BadWhitespace /\s\+$/
augroup END
