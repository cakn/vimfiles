set nocompatible

" Removes all autocmds
" autocmd!

execute pathogen#infect()

filetype plugin indent on
syntax enable

" Autocommands {{{
" Autosource vimrc
" autocmd bufwritepost .vimrc source $MYVIMRC

autocmd FileType _vimrc,.vimrc setlocal foldmethod=marker

" Disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Highlight word cursor is on
" autocmd CursorMoved * match CursorSelect /\w*\%#\w*/
autocmd CursorMoved * exe printf('match CursorSelect /\V\<%s\>/', escape(expand('<cword>'), '/\'))
" }}}

" Settings {{{
" Prevent exploits
set nomodeline

set background=dark
set t_Co=256
colorscheme solarized
"set guifont=Lucida_Sans_Typewriter:h12:cANSI
set guifont=Ubuntu_Mono_derivative_Powerlin:h12:cANSI

" Make sure colorscheme is set first
highlight CursorSelect ctermbg=0 guibg=#073642

set autoread

set confirm

set number
set showcmd
set ruler
set laststatus=2

set autoindent
set cindent
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Disable textwidth so vim doesn't autobreak long lines
set textwidth=0

set wildmenu
set wildmode=longest:full

set completeopt=longest,menu,preview

" Backspace over lines and tabs
set backspace=2
" Allow left and right to move between lines
set whichwrap=b,s,h,l,<,>,[,]

set ignorecase
set smartcase
set incsearch
set hlsearch
" This is to stop hl from triggering when we re-source this
nohl

set scrolloff=2

set nostartofline

set mouse=a

set listchars=tab:>-

" Set default clipboard to system's
set clipboard=unnamed
if !has("win32")
	set clipboard=unnamedplus
endif

set foldmethod=syntax
set foldcolumn=2
set foldopen=block,hor,mark,percent,quickfix,search,tag,undo

" Fast terminal
set tf

"Set encoding up here to avoid problems with alt
set encoding=utf-8
" Settings }}}

" Text Objects {{{
" camelCase text object
vnoremap am :<C-U>let @z=@/<CR><Right>?\<\\|\L<CR><ESC>v/\>\\|\L<CR>:<C-U>let @/=@z<CR>gv
vnoremap im :<C-U>let @z=@/<CR><Right>?\<\\|\L<CR><ESC>v/\>\\|\L/e-1<CR>:<C-U>let @/=@z<CR>gv
onoremap am :normal vam<CR>
onoremap im :normal vim<CR>
onoremap m :normal vim<CR>

" param text object
vnoremap aj :<C-U>let @z=@/<CR><Right>?\s*\<\(\w\\|\[\\|\]\)\+\s\+\w\+\s*[,)]<CR><ESC>v/\(\w\\|\[\\|\]\)\+\s\+\w\+\s*,\=\ze)\=/e<CR>:<C-U>let @/=@z<CR>gv
vnoremap ij :<C-U>let @z=@/<CR><Right>?\s*\zs\<\(\w\\|\[\\|\]\)\+\s\+\w\+\s*\ze[,)]<CR><ESC>v/\(\w\\|\[\\|\]\)\+\s\+\w\+\s*\ze,\=)\=/e<CR>:<C-U>let @/=@z<CR>gv
onoremap aj :normal vaj<CR>
onoremap ij :normal vij<CR>
onoremap j :normal vij<CR>

onoremap w iw
onoremap ) i)
onoremap ( i(
onoremap { i{
onoremap } i}
onoremap [ i[
onoremap ] i]
onoremap " i"
onoremap ' i'
onoremap < i<
onoremap > i>
" Text Objects }}}

" Mappings {{{
" let home and end keys to work in screen
map [1~ <Home>
map [4~ <End>
imap [1~ <Home>
imap [4~ <End>

" Change : to ; for convenience
noremap ; :
nnoremap , ;

" Swap jump to marks
noremap ' `
noremap ` '

" Swap 0 and ^
noremap 0 ^
noremap ^ 0

" Move left easier
noremap s b
noremap <S-S> B

" Make marks harder
nnoremap m <Nop>
nnoremap <A-M> m
nnoremap m m

" Buffer moving
nnoremap bn :bn<CR>
nnoremap bp :bp<CR>

" Ctrl+S saving
nnoremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <Esc>:update<CR>
" Ctrl+c jk copy line
nnoremap <C-C>j yyp
nnoremap <C-C>k yyP
vnoremap <C-C>j y`>p
vnoremap <C-C>k y`<P

" Ctrl+c copy
vnoremap <C-C> y
" Y copy to end of line
nnoremap Y y$

" Copy variable declarations
" Copies from start of line to =
nnoremap <Leader>cvd :let @z=@/\|.g/^\s*\w*\s\+\w*\s*=/y X\|s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
vnoremap <Leader>cvd :<C-U>let @z=@/<CR>gv:g/^\s*\w*\s\+\w*\s*=/y X<CR>gv:s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
nnoremap <Leader>pvd :let @z=@/<CR>"xp:'[,']s/\s*=.*/;/\|let @/=@z<CR>qxq

" Ctrl+v pasting
nnoremap <C-V> p
nnoremap <A-V> <C-V>
nnoremap v <C-V>
inoremap <C-V> <C-O>p
inoremap <A-V> <C-V>
inoremap v <C-V>
cnoremap <C-V> <C-R>"
cnoremap <A-V> <C-V>
cnoremap v <C-V>

" yank pasting
nnoremap py "0p
nnoremap pc p

" Paste to new line
nnoremap <C-P> mz:pu<CR>='z

" Ctrl+y copy word above
inoremap <C-Y> a<Esc>kyw`^a<BS><C-O>p
" Copy word by camel
inoremap <C-T> a<Esc>k:norm yim<CR>`^a<BS><C-O>p

" Insert line
nnoremap <CR> o<Esc>

" Quick escape insert mode
" inoremap qr <Esc>:normal! :let @z=@/\\\|.g/^\s*$/d<CR>:let @/=@z<CR>
inoremap qr <Esc>:let @z=@/\|.g/^\s*$/d<CR>:let @/=@z<CR>
vnoremap qr <Esc>:let @z=@/\|.g/^\s*$/d<CR>:let @/=@z<CR>
" Disable q to prevent accidental recording
nnoremap qr <Nop>
nnoremap q <Nop>
nnoremap <A-q> q
nnoremap q q

" Copy line and increment number
nnoremap <A-A> mzyy<C-A>P`z
nnoremap a mzyy<C-A>P`z

" Quick delete
nnoremap dw daw
nnoremap dj :normal daj<CR>
" Stops vim from for command after dd
nnoremap dd dd
" Quick inner word
" nnoremap cw ciw
" " Quick yank word
" nnoremap yw yiw
" " Quick inner )
" nnoremap c) ci)
" nnoremap c( ci(
" nnoremap c{ ci{
" nnoremap c} ci}
" nnoremap c[ ci[
" nnoremap c] ci]
" nnoremap c" ci"
" nnoremap c' ci'
" nnoremap c< ci<
" nnoremap c> ci>

" Quick move lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Terminal inputs
nnoremap j :m .+1<CR>==
nnoremap k :m .-2<CR>==
inoremap j <Esc>:m .+1<CR>==gi
inoremap k <Esc>:m .-2<CR>==gi
vnoremap j :m '>+1<CR>gv=gv
vnoremap k :m '<-2<CR>gv=gv

"hjkl move in insert
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>
inoremap <C-H> <Left>
" hjkl move in command liine
cnoremap <C-J> <C-N>
cnoremap <C-K> <C-P>
cnoremap <C-H> <Left>
cnoremap <C-L> <Right>

" Move to end of line
inoremap <C-E> <C-O>$

" Delete characteer in insert mode
inoremap <C-R> <Del>
inoremap <A-R> <C-R>
inoremap r <C-R>

"Shift j k to move quickly up and down
nnoremap <S-J> L3j
nnoremap <S-K> H3k
"Join and split lines
" nnoremap <C-J> <S-J>
" nnoremap <C-K> i<CR><Esc>

" Tab outside insert mode
"nnoremap <Tab> >>
"vnoremap <Tab> >gv " Disable for Snipmate compatibility
" Shift tab to deindent
"nnoremap <S-Tab> <<
"inoremap <S-Tab> <C-D>
"vnoremap <S-Tab> <gv

" Surround visual selection
vnoremap " <ESC>`>a"<ESC>`<i"<ESC>
vnoremap ' <ESC>`>a'<ESC>`<i'<ESC>
vnoremap ( <ESC>`>a )<ESC>`<i( <ESC><Left>
vnoremap ) <ESC>`>a)<ESC>`<i(<ESC>
vnoremap [ <ESC>`>a ]<ESC>`<i[ <ESC><Left>
vnoremap ] <ESC>`>a]<ESC>`<i[<ESC>
vnoremap { <ESC>`>a }<ESC>`<i{ <ESC><Left>
vnoremap } <ESC>`>a}<ESC>`<i{<ESC>

" Negate boolean variable with !
nnoremap ! :let @z=@/<CR>mzviWvBi!<Esc>:s /!!=/==/e<CR>:s /!!//e<CR>:s /!true/false/e<CR>:s /!false/true/e<CR>:s /!==/!=/e<CR>:let @/=@z<CR>`z
nnoremap <C-!> !

" Auto brace completion
inoremap {<CR>  {<CR>}<Esc>O
inoremap <expr> (<Space> pumvisible() ? "\<CR>(\<Space>)\<Left>" : "(\<Space>)\<Left>"
inoremap [ []<Left>

" Turn off highlighting with <C-L> (redraw screen)
nnoremap <C-L> :nohlsearch\|let @/=""<CR><C-L>

" autocomplete with Ctrl+Space
inoremap <C-Space> <C-X><C-U><C-R>=pumvisible() ? "\<lt>Down>" : ""<CR>
" <Nul> for terminal
inoremap <Nul> <C-X><C-U><C-R>=pumvisible() ? "\<lt>Down>" : ""<CR>
" Ctrl+n highlight first
inoremap <C-N> <C-N><C-R>=pumvisible() ? "\<lt>Down>" : ""<CR>
" autoenter with nonchar
inoremap <expr> . pumvisible() ? "\<CR>." : "."
inoremap <expr> ( pumvisible() ? "\<CR>(" : "("
inoremap <expr> <Space> pumvisible() ? "\<CR>\<Space>" : "\<Space>"
" Quick ;<Enter>
inoremap <expr> ; pumvisible() ? "\<CR>;" : ";\<CR>"

" Close file
noremap <Leader>cl :clo<CR>

" Edit vimrc, gvimrc files
nnoremap <Leader>ev :tabnew $MYVIMRC<CR>
nnoremap <Leader>egv :tabnew $MYGVIMRC<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>
nnoremap <Leader>sgv :so $MYGVIMRC<CR>

" Quick notes file
nnoremap <Leader>no :tabnew ~/vimNotes.txt<CR>

" Toggle background colors
nnoremap <Leader>tbg :call <SID>toggleBackground()<CR>

" Set directory to currently open file's
nnoremap <Leader>cd :cd %:h<CR>

" Fix trailing spaces
nnoremap <Leader>dts mz:let @z=@/<CR>:%s/\s\+$//e\|let @/=@z<CR>`z

" Open directory of file in explorer
if has("win32")
	nnoremap <silent> <Leader>od :silent :!start explorer %:p:h:gs?\/?\\\\\\?<CR>
endif
" Mappings }}}

"==================FUNCTIONS ====================
fun! <SID>toggleBackground()
	if( &background == "dark" )
		set background=light
		highlight CursorSelect ctermbg=7 guibg=#eee8d5
	else
		set background=dark
		highlight CursorSelect ctermbg=0 guibg=#073642
	endif
endfun

"==================PLUGINS ======================
" Insert one character
nnoremap <space> :<C-U>call InsertChar#insert(v:count1)<CR>

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#whitespace#checks = [ 'trailing' ]

" Snipmate
silent! iunmap <C-R><Tab>
