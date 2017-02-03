" Enable spell check
setlocal spell spelllang=en

" Keep highlighting the badly spelled word, even if colorscheme overrides
highlight clear SpellBad
highlight SpellBad cterm=bold,italic ctermfg=red

" Add spelling support to completion
setlocal complete+=kspell
