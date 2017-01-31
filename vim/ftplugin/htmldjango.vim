func! Eatchar(pat)
   let c = nr2char(getchar(0))       
   return (c =~ a:pat) ? '' : c      
endfunc

iabbrev dif {% if %}<left><left><left>
iabbrev delse {% else %}<C-R>=Eatchar('\s')<CR>
iabbrev dendif {% endif %}<C-R>=Eatchar('\s')<CR>
iabbrev dfor {% for %}<left><left><left>
iabbrev dendfor {% endfor %}<C-R>=Eatchar('\s')<CR>
iabbrev dload {% load i18n %}<left><left><left><left><left><left><left><C-R>=Eatchar('\s')<CR>
iabbrev dtr {% trans "" %}<left><left><left><left><C-R>=Eatchar('\s')<CR>
iabbrev durl {% url "" %}<left><left><left><left><C-R>=Eatchar('\s')<CR>
iabbrev dv {{ }}<left><left><left>
iabbrev dt {% %}<left><left><left>
