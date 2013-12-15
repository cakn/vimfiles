set nocompatible

" Removes all autocmds
" autocmd!

execute pathogen#infect()
Helptags

filetype plugin indent on
syntax enable

" Autocommands {{{
" Autosource vimrc
" autocmd bufwritepost .vimrc source $MYVIMRC

" Restore last cursor position of file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Enable marker folds for .vimrc files
autocmd FileType vim setlocal foldmethod=marker

" Disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Highlight word cursor is on
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
set relativenumber
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

set cmdheight=2

set nostartofline

set mouse=a

set listchars=tab:>-

" Set default clipboard to system's
" set clipboard=unnamed
" if !has("win32")
" 	set clipboard=unnamedplus
" endif

" set foldmethod=syntax
" set foldcolumn=2
" set foldopen=block,hor,mark,percent,quickfix,search,tag,undo,jump

" if has("win32")
" 	set shell=\"C:\Program\ Files\ (x86)\Git\bin\sh.exe\"
" 	set shellcmdflag=--login\ -c
" endif

" Fast terminal
set tf

" Match <>
set matchpairs+=<:>

"Set encoding up here to avoid problems with alt
set encoding=utf-8
" Settings }}}

" Text Objects {{{
" camelCase text object
vnoremap al :<C-U>let @z=@/<CR><Right>?\<\\|\L<CR><ESC>v/\>\\|\L<CR>:<C-U>let @/=@z<CR>gv
vnoremap il :<C-U>let @z=@/<CR><Right>?\<\\|\L<CR><ESC>v/\>\\|\L<CR><Left>:<C-U>let @/=@z<CR>gv
onoremap al :normal vam<CR>
onoremap il :normal vim<CR>
onoremap l :normal vim<CR>

" param text object
" vnoremap aj :<C-U>let @z=@/<CR><Right>?\s*\<\(\w\\|[\[\]*:]])\+\s\+\w\+\s*[,)]<CR><ESC>v/\(\w\\|\[\\|\]\\|\*\)\+\s\+\w\+\s*,\=\ze)\=/e<CR>:<C-U>let @/=@z<CR>gv
" vnoremap <Leader>1 <Esc><Left>?[(,]?e-1<CR>v
" vnoremap <Leader>2 /[,)]<CR>o<Esc>
" nnoremap <Leader>3 /\(\%V[(,][^,]*\ze)\)\\|\(\%V[,(]\zs[^,]*,\)<CR>
" nnoremap <Leader>4 v/\(\%V[(,][^,]\{-}\ze\s*)\)\\|\(\%V[^,]*,\)/e<CR>
vnoremap aj <Esc>:let @z=@/<CR><Left>?[(,]?e-1<CR>v/[,)]<CR>o<Esc>/\(\%V[(,][^,]*\ze)\)\\|\(\%V[,(]\zs[^,]*,\)<CR>v/\(\%V[(,][^,]\{-}\ze\s*)\)\\|\(\%V[^,]*,\)/e<CR>:<C-U>let @/=@z<CR>gv
" vnoremap ij :<C-U>let @z=@/<CR><Right>?\s*\zs\<\(\w\\|\[\\|\]\\|\*\)\+\s\+\w\+\s*\ze[,)]<CR><ESC>v/\(\w\\|\[\\|\]\\|\*\)\+\s\+\w\+\s*\ze,\=)\=/e<CR>:<C-U>let @/=@z<CR>gv
" vnoremap <Leader>1 <Esc><Left>?[(,]?e<CR>v
" vnoremap <Leader>2 /[,)]<CR>o<Esc>
" nnoremap <Leader>3 /\(\s*\zs[^,]*\ze)\)\\|\(\s*\zs[^(,]*\ze,\)/s<CR>
" " Move left instead of s-1 for 1 letter case
" nnoremap <Leader>4 v/\(\s*[,)]\)/s<CR><Left>
vnoremap ij <Esc>:let @z=@/<CR><Left>?[(,]?e<CR>v/[,)]<CR>o<Esc>/\(\s*\zs[^,]*\ze)\)\\|\(\s*\zs[^(,]*\ze,\)/s<CR>v/\(\s*[,)]\)/s<CR><Left>:<C-U>let @/=@z<CR>gv
onoremap aj :normal vaj<CR>
onoremap ij :normal vij<CR>
onoremap j :normal vij<CR>

" Function text object
vnoremap iy <Esc>[[v%<Left>o<Right>
vnoremap ay <Esc>:let @z=@/<CR>[[?\<\w\+\s\+\w\+(<CR>:let @/=@z<CR>v]]%

onoremap k iw
onoremap K iW
onoremap ak aw
onoremap ik iw
onoremap aK aW
onoremap iK iW
onoremap w iw
onoremap W iW
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

" Allow typing ` with quake console
inoremap ~~ `

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
nnoremap s b
nnoremap <S-S> B

" Make marks harder
nnoremap m <Nop>
nnoremap <A-m> m
nnoremap m m

" Buffer moving
nnoremap bn :bn<CR>
nnoremap bp :bp<CR>
nnoremap bd :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap bb :b#<CR>

" Tag moving
nnoremap go g<C-]>

" Windows
nnoremap w <C-w>

" Ctrl+S saving
nnoremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <Esc>:update<CR>:let @z=@/\|.g/^\s*$/d<CR>:let @/=@z<CR>

" Ctrl+c jk copy line
nnoremap <C-C>j mzyyp`zj
nnoremap <C-C>k mzyyP`zk
vnoremap <C-C>j y`>p
vnoremap <C-C>k y`<P

" Ctrl+c copy
vnoremap <C-C> "+y
" Y copy to end of line
nnoremap Y y$

" Copy variable declarations
" Copies from start of line to =
nnoremap <Leader>cvd :let @z=@/\|.g/^\s*\w*\s\+\w*\s*=/y X\|s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
vnoremap <Leader>cvd :<C-U>let @z=@/<CR>gv:g/^\s*\w*\s\+\w*\s*=/y X<CR>gv:s/^\s*\zs\w*\s\+\ze\w*\s*=//\|let @/=@z<CR>
nnoremap <Leader>pvd :let @z=@/<CR>"xp:'[,']s/\s*=.*/;/\|let @/=@z<CR>qxq

" Ctrl+v pasting
nnoremap <C-V> p
nnoremap <A-v> <C-V>
nnoremap v <C-V>
inoremap <C-V> <C-O>"+p
inoremap <A-v> <C-V>
inoremap v <C-V>
cnoremap <C-V> <C-R>"
cnoremap <A-v> <C-V>
cnoremap v <C-V>
vnoremap <C-V> "+p

" yank pasting
nnoremap py "0p
nnoremap pc "+p
nnoremap pp p
inoremap <C-P>c <C-O>"+p
inoremap <C-P>y <C-O>p
nnoremap Py "0P
nnoremap Pc "+P
nnoremap PP P

" Paste to new line
nnoremap <C-P> mz:pu<CR>='z

" Ctrl+y copy word above
inoremap <C-Y> a<Esc>kyw`^a<BS><C-O>p
" Copy word by camel
inoremap <C-T> a<Esc>k:norm yim<CR>`^a<BS><C-O>p

" Insert line
nnoremap <CR> o<Esc>

"Swap letters
nnoremap gl xhpl

" Quick escape insert mode
" inoremap qr <Esc>:normal! :let @z=@/\\\|.g/^\s*$/d<CR>:let @/=@z<CR>
inoremap wj <Esc>:let @z=@/\|.g/^\s*$/d<CR>:let @/=@z<CR>
vnoremap wj <Esc>:let @z=@/\|.g/^\s*$/d<CR>:let @/=@z<CR>
xnoremap wj <Esc>:let @z=@/\|.g/^\s*$/d<CR>:let @/=@z<CR>
" Disable q to prevent accidental recording
" nnoremap qr <Nop>
" nnoremap q <Nop>
" nnoremap <A-q> q
" nnoremap q q

" Copy line and increment number
nnoremap <A-a> mzyy<C-A>P`z
nnoremap a mzyy<C-A>P`z

" Quick delete
" Map each to avoid recursive calls in normal
nnoremap dw daw
nnoremap dW daW
nnoremap dj :normal daj<CR>
nnoremap dl :normal dil<CR>
" Stops vim from waiting for a command after dd
nnoremap dd dd
" Change bracket to leave space
nnoremap c( ci(<Space><Space><Left>
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
vnoremap <A-j> :m '>+1<CR>gv
vnoremap <A-k> :m '<-2<CR>gv
" Terminal inputs
nnoremap j :m .+1<CR>==
nnoremap k :m .-2<CR>==
inoremap j <Esc>:m .+1<CR>==gi
inoremap k <Esc>:m .-2<CR>==gi
vnoremap j :m '>+1<CR>gv
vnoremap k :m '<-2<CR>gv

" Move word
nnoremap <A-h> dawbPh
nnoremap h dawbPh
nnoremap <A-l> dawelph
nnoremap l dawelph

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
" Move to beginning of line
inoremap <C-W> <C-O>^

" Delete character in insert mode
inoremap <C-R> <Del>
inoremap <A-r> <C-R>
inoremap r <C-R>

"Shift j k to move quickly up and down
nnoremap <S-J> L3j
nnoremap <S-K> H3k
"Join and split lines
" nnoremap <C-J> <S-J>
" nnoremap <C-K> i<CR><Esc>

nnoremap >> >>
nnoremap << <<
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
" inoremap <expr> (<Space> pumvisible() ? "\<CR>(\<Space>)\<Left>" : "(\<Space>)\<Left>"
" inoremap [ []<Left>

" Turn off highlighting with <C-L> (redraw screen)
nnoremap <C-L> :nohlsearch\|let @/=""<CR><C-L>

" Autocomplete on Ctrl-F
inoremap <C-F> <C-X>

" autocomplete with Ctrl+Space
" inoremap <C-Space> <C-X><C-U><C-R>=pumvisible() ? "\<lt>Down>" : ""<CR>
" <Nul> for terminal
" inoremap <Nul> <C-X><C-U><C-R>=pumvisible() ? "\<lt>Down>" : ""<CR>
" Ctrl+n highlight first
" inoremap <C-N> <C-N><C-R>=pumvisible() ? "\<lt>Down>" : ""<CR>
" autoenter with nonchar
" inoremap <expr> . pumvisible() ? "\<CR>." : "."
" inoremap <expr> ( pumvisible() ? "\<CR>(" : "("
" inoremap <expr> <Space> pumvisible() ? "\<CR>\<Space>" : "\<Space>"
" " Quick ;<Enter>
" inoremap <expr> ; pumvisible() ? "\<CR>;" : ";\<CR>"
inoremap ; ;<CR>

" Close file
noremap <Leader>cl :clo<CR>

" Move window to new tab
nnoremap <Leader>bt <C-W>s<C-W>T

" Make file
nnoremap <Leader>mk :make<CR>
nnoremap <Leader>md :make debug<CR>
nnoremap <Leader>mr :make run<CR>

" Edit vimrc, gvimrc files
nnoremap <Leader>ev :tabnew $MYVIMRC<CR>
nnoremap <Leader>egv :tabnew $MYGVIMRC<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>
nnoremap <Leader>sgv :so $MYGVIMRC<CR>

" Quick notes file
nnoremap <Leader>en :tabnew ~/vimNotes.txt<CR>

"Bash rc files
nnoremap <Leader>eb :tabnew ~/.bashrc<CR>
nnoremap <Leader>ei :tabnew ~/.inputrc<CR>

if( has("win32") )
	nnoremap <Leader>ehk :tabnew ~/Documents/Autohotkey/Autohotkey.ahk<CR>
endif

" Toggle background colors
nnoremap <Leader>tbg :call <SID>toggleBackground()<CR>

" Set directory to currently open file's
nnoremap <Leader>cd :cd %:h<CR>

" Fix trailing spaces
nnoremap <Leader>dts mz:let @z=@/<CR>:%s/\s\+$//e\|let @/=@z<CR>`z

" Run ctags
nnoremap <Leader>xctag :!ctags-exuberant *.cpp *.h<CR>

if has("win32")
	" Open directory of file in explorer
	nnoremap <silent> <Leader>od :silent :!start explorer %:p:h:8<CR>

	" Run file
	nnoremap <Leader>xe :silent :!cd %:p:h:8 && start %:p:8<CR>
endif

nnoremap <Leader>xp :!python %:p:8<CR>
" Mappings }}}

"==================FUNCTIONS ====================
function! VimColorTest(outfile, fgend, bgend)
	let result = []
		for fg in range(a:fgend)
			for bg in range(a:bgend)
				let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
				let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
				let s = printf('syn keyword %s %s', kw, kw)
				call add(result, printf('%-32s | %s', h, s))
			endfor
		endfor
	call writefile(result, a:outfile)
	execute 'edit '.a:outfile
	source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTest call VimColorTest('vim-color-test.tmp', 12, 16)

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
" Disable this hotkey
silent! iunmap <C-R><Tab>
imap <C-o> <Esc>a<Plug>snipMateNextOrTrigger
vmap <C-o> <Plug>snipMateNextOrTrigger
" Reload snippets
nnoremap <Leader>rls :call ReloadAllSnippets()<CR>

" Commentary
autocmd FileType autohotkey setlocal commentstring=;%s

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" let g:UltiSnipsExpandTrigger = '<C-b>'
" let g:UltiSnipsListSnippets = '<C-b>'
" let g:UltiSnipsJumpForwardTrigger = '<C-b>'
" let g:UltiSnipsJumpBackwardTrigger = '<C-b>'

" FSwitch
nnoremap <Leader>g; :FSHere<CR>
nnoremap <Leader>gh :FSLeft<CR>
nnoremap <Leader>gsh :FSSwitchLeft<CR>
nnoremap <Leader>gl :FSRight<CR>
nnoremap <Leader>gsl :FSSwitchRight<CR>

"Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files -start-insert file<cr>

" text object function
" let g:textobj_function_no_default_key_mappings=1
