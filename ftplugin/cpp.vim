" Copy variable declarations
" Copies from start of line to =
nnoremap <Leader>cvd :let @z=@/\|.g/^\s*\w*\s\+\w*\s*=/y X\|s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
vnoremap <Leader>cvd :<C-U>let @z=@/<CR>gv:g/^\s*\w*\s\+\w*\s*=/y X<CR>gv:s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
nnoremap <Leader>pvd :let @z=@/<CR>"xp:'[,']s/\s*=.*/;/\|let @/=@z<CR>qxq

" Auto brace completion
inoremap {<CR>  {<CR>}<Esc>O

inoremap ; <ESC>A;<CR>
inoremap <A-;> ;
