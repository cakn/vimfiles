" CamelCaseMotion plugin
silent! unmap ,w
silent! unmap ,b
silent! unmap ,e

" Commentary
silent! nunmap gcc
silent! nunmap gcu

nnoremap gc mz:execute "normal \<Plug>CommentaryLine"<CR>`z
xnoremap gc mz:<C-U>execute "'<,'>normal \<Plug>CommentaryLine"<CR>`z

" Snipmate
silent! iunmap <C-R><Tab>
