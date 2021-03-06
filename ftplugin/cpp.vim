" Copy variable declarations
" Copies from start of line to =
nnoremap <Leader>cvd :let @z=@/\|.g/^\s*\w*\s\+\w*\s*=/y X\|s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
vnoremap <Leader>cvd :<C-U>let @z=@/<CR>gv:g/^\s*\w*\s\+\w*\s*=/y X<CR>gv:s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
nnoremap <Leader>pvd :let @z=@/<CR>"xp:'[,']s/\s*=.*/;/\|let @/=@z<CR>qxq

vnoremap * <ESC>`>a*/<ESC>`<i/*<ESC>

" Auto brace completion
inoremap {<CR>  {<CR>}<Esc>O

inoremap ; <ESC>A;<CR>
inoremap <A-;> ;

" insert filename
inoremap fln <C-R>=expand("%:t:r")<CR>::

" function declaration paste
nmap <Leader>cfp V<<<<<Esc>Hf(Sifln<C-e><BS><CR>{<CR>

" Search cpp only
set grepprg=ag\ --cpp

set foldmethod=syntax
set foldlevelstart=2
