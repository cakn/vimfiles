" Commentary
silent! nunmap gcc
silent! nunmap gcu
nmap gc :normal! mz<CR><Plug>CommentaryLine:normal! `z<CR>
xmap gc <Esc>:normal! mzgv<CR><Plug>Commentary:normal! `z<CR>

" Snipmate
silent! iunmap <C-R><Tab>
