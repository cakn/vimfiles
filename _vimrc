set nocompatible

" Removes all autocmds
" autocmd!

let g:pathogen_disabled = []
" call add( g:pathogen_disabled, 'YouCompleteMe' )

execute pathogen#infect()
Helptags

filetype plugin indent on
syntax enable

" Autocommands {{{
" Autosource vimrc
" autocmd bufwritepost .vimrc source $MYVIMRC

" Restore last cursor position of file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Enable marker folds for .vimrc files and shell files
autocmd FileType vim,sh setlocal foldmethod=marker

" Disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Highlight word cursor is on
autocmd CursorMoved * exe printf('match CursorSelect /\V\<%s\>/', escape(expand('<cword>'), '/\'))

au BufNewFile,BufRead *.jsfl set filetype=javascript

" }}}


" Settings {{{
" Prevent exploits
set nomodeline

"set guifont=Lucida_Sans_Typewriter:h12:cANSI
" set guifont=Ubuntu_Mono_derivative_Powerlin:h12:cANSI
set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12

" Make sure colorscheme is set first before highlight

if !has("gui_running")
	" Good enough settings for cygwin with conemu
	set term=xterm-256
	set t_Co=16
	" set term=cygwin
	" let g:solarized_termcolors=16
	" let g:solarized_termtrans=1
	set background=dark
	let g:solarized_bold=0
	let g:solarized_italic=0
	let g:solarized_underline=0
	colorscheme solarized
	highlight CursorSelect ctermbg=0 guibg=#073642
	highlight MatchParen ctermbg=7 guibg=#eee8d5
	if has("gui_running")
		set background=light
		highlight CursorSelect ctermbg=7 guibg=#eee8d5
	endif
else
	" colorscheme wombat
	colorscheme Tomorrow
	" highlight CursorSelect ctermbg=0 guibg=#333333
	highlight CursorSelect ctermbg=0 guibg=#EAEAEA

	" let g:molokai_original=1
	" let g:rehash256=1
	" set background=dark
	" colorscheme molokai
	" highlight CursorSelect ctermbg=0 guibg=#333333
endif


set autoread

set confirm

set number
set relativenumber
set showcmd
set ruler
set laststatus=2
set showbreak=…

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

set lazyredraw

"Set encoding up here to avoid problems with alt
set encoding=utf-8
" Settings }}}


" Text Objects {{{
" camelCase text object
" vnoremap al :<C-U>let @z=@/<CR><Right>?\<\\|\L<CR>v/\>\\|\L<CR>:<C-U>let @/=@z<CR>gv
" vnoremap il :<C-U>let @z=@/<CR><Right>?\<\\|\L<CR>v/\>\\|\L<CR><Left>:<C-U>let @/=@z<CR>gv
" onoremap al :normal val<CR>
" onoremap il :normal vil<CR>
" onoremap l :normal vil<CR>

" CamelCaseMotion plugin
" ie seems to do what is wanted instead of iw
" omap il <Plug>CamelCaseMotion_iw
" xmap il <Plug>CamelCaseMotion_iw
" omap l <Plug>CamelCaseMotion_iw
" omap <silent> iw <Plug>CamelCaseMotion_iw
omap il <Plug>CamelCaseMotion_ie
xmap il <Plug>CamelCaseMotion_ie
omap l <Plug>CamelCaseMotion_ie
omap <silent> iw <Plug>CamelCaseMotion_ie

onoremap y l

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
vnoremap iu <Esc>[[v%<Left>o<Right>
vnoremap au <Esc>:let @z=@/<CR>[[?\<\w\+\s\+\w\+(<CR>:let @/=@z<CR>v]]%

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

" Mouse mappings
" doubleclick to open fold
nmap <2-LeftMouse> za

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
noremap q; q:
noremap @; @:

" Swap jump to marks
noremap ' `
noremap ` '

" Swap 0 and ^
noremap 0 ^
noremap ^ 0

" Move left easier
nnoremap s b
nnoremap <S-S> B
vnoremap s b

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
inoremap <C-S> <Esc>:call <SID>escape()<CR>:update<CR>

" Ctrl+c jk comment and copy line
nnoremap <C-C>j mzyyp`z:normal gcc<CR>j
nnoremap <C-C>k mzyyP`z:normal gcc<CR>k
vnoremap <C-C>j ygv:normal gcc<CR>`>p
vnoremap <C-C>k ygv:normal gcc<CR>`<P
" Shift+Alt copy line
nnoremap <A-J> mzyyp`zj
nnoremap <A-K> mzyyp`z
inoremap <A-J> <Esc>yyp`^<Down>i
inoremap <A-K> <Esc>yyP`^<Up>i

" Ctrl+u copy line
nnoremap <C-U> mzyyp`zj

" Ctrl+c copy
vnoremap <C-C> "+y
" Y copy to end of line
nnoremap Y y$
" redefine yy to work even if we remap y to an text object
nnoremap yy yy

" Ctrl+v pasting
nnoremap <C-V> "+P
nnoremap <A-v> <C-V>
nnoremap v <C-V>
inoremap <C-V> <C-O>:set paste<CR><C-R>+<C-O>:set nopaste<CR>
inoremap <A-v> <C-V>
inoremap v <C-V>
cnoremap <C-V> <C-R>+
cnoremap <A-v> <C-V>
cnoremap v <C-V>
vnoremap <C-V> "+P

" yank pasting
nnoremap py "0p
nnoremap pc "+p
nnoremap pp p
inoremap <C-P>c <C-O>"+P
inoremap <C-P><C-C> <C-O>"+P
inoremap <C-P>y <C-O>"0P
inoremap <C-P><C-Y> <C-O>"0P
nnoremap Py "0P
nnoremap Pc "+P
nnoremap PP P

" Replace word with last yanked
nnoremap pw "_ciw<C-R>0<Esc>
nnoremap pk "_ciw<C-R>0<Esc>

" Paste to new line
nnoremap <C-P> mz:pu<CR>='z

" Ctrl+y copy word above
inoremap <C-Y> a<Esc>kyw`^a<BS><C-O>p
" Copy word by camel
inoremap <C-T> a<Esc>k:norm yim<CR>`^a<BS><C-O>p

" Insert line
nnoremap <CR> o<Esc>

" Insert mode insert lines
inoremap <S-CR> <C-o>O
inoremap <C-CR> <C-o>o

" Quick escape insert mode
inoremap sj <Esc>:call <SID>escape()<CR>
vnoremap sj <Esc>:call <SID>escape()<CR>
xnoremap sj <Esc>:call <SID>escape()<CR>

" Copy line and increment number
nnoremap <A-a> mzyy<C-A>P`z
nnoremap a mzyy<C-A>P`z

" Quick delete
" Map each to avoid recursive calls in normal
nnoremap dw daw
nnoremap dW daW
nnoremap dk daw
nnoremap dK daW
nnoremap d" da"
nnoremap d< da<
nnoremap d> da>
nnoremap d' da'
nnoremap d( di(
nnoremap d) da)
nnoremap d{ da{
nnoremap d} da}
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

"Swap letters
nnoremap gl Xp

" Swap word
nnoremap <A-h> "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:noh<CR><c-o>
nnoremap <A-l> "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR>:noh<CR>
nnoremap h "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:noh<CR><c-o>
nnoremap l "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:noh<CR><c-o>

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
inoremap <C-D> <Del>
" inoremap <A-r> <C-R>
" inoremap r <C-R>
" cnoremap <A-r> <C-R>

"Shift j k to move quickly up and down
nnoremap <S-J> L3j
vnoremap <S-J> L3j
nnoremap <S-K> H3k
vnoremap <S-K> H3k
"Join and split lines
" nnoremap <C-J> <S-J>
" nnoremap <C-K> i<CR><Esc>

"Shift H L to move to front/end of the line
nnoremap H <Home>
nnoremap L <End>

" Swap [ and { to move quickly between functions
nnoremap [ [[
nnoremap ] ]]

nnoremap >> >>
nnoremap << <<
vnoremap > >gv
vnoremap < <gv
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

"Visual mode set register
vnoremap <C-R> "

" Negate boolean variable with !
nnoremap ! :let @z=@/<CR>mzviWovi!<Esc>:s /!!=/==/e<CR>:s /!!//e<CR>:s /!true/false/e<CR>:s /!false/true/e<CR>:s /!==/!=/e<CR>:let @/=@z<CR>`z
nnoremap <C-!> !

" inoremap <expr> (<Space> pumvisible() ? "\<CR>(\<Space>)\<Left>" : "(\<Space>)\<Left>"
" inoremap [ []<Left>

" Turn off highlighting with <C-L> (redraw screen)
nnoremap <C-L> :nohlsearch<CR><C-L>

" To end of word in insert mode
inoremap <C-F> <Esc>ea

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

" Close file
noremap <Leader>cl :clo<CR>

" New tab
nnoremap <Leader>tn :tabnew<CR>
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
nnoremap <Leader>ebb :tabnew ~/.bashrc<CR>
nnoremap <Leader>ebi :tabnew ~/.inputrc<CR>

" File plugin files
nnoremap <Leader>ef :tabnew ~/.vim/ftplugin<CR>
nnoremap <Leader>eap :tabnew ~/.vim/after/plugin<CR>

" Plugins
" Snippet files
" nnoremap <Leader>eps :tabnew ~/.vim/bundle/vim-snippets/UltiSnips/<CR>
nnoremap <Leader>eps :UltiSnipsEdit<CR>

if( has("win32") || has("win32unix") )
	nnoremap <Leader>ehk :tabnew ~/Autohotkey.ahk<CR>
	nnoremap <Leader>es :tabnew ~/_vsvimrc<CR>
endif

" Toggle background colors
nnoremap <Leader>tbg :call <SID>toggleBackground()<CR>

" Set directory to currently open file's
nnoremap <Leader>cd :cd %:h<CR>

" Insert file name
nnoremap <Leader>ifn i<C-R>=expand("%:t:r")<CR><Esc>

" Fix trailing spaces
nnoremap <Leader>dts :call <SID>deleteTrailingSpaces()<CR>

" Run ctags
nnoremap <Leader>xctag :!ctags-exuberant *.cpp *.h<CR>

" Run python on selected
nnoremap <Leader>py :.!python<CR>
vnoremap <Leader>py :!python<CR>

" Insert fold marker
nnoremap <Leader>ifo o{{{<Esc>:normal gc<CR>
nnoremap <Leader>ifc o}}}<Esc>:normal gc<CR>

if has("win32")
	" Open directory of file in explorer
	nnoremap <silent> <Leader>od :silent :!start explorer %:p:h:8<CR>

	" Run file
	nnoremap <Leader>xe :silent :!cd %:p:h:8 && start %:p:8<CR>
elseif has("win32unix") 
	nnoremap <silent> <Leader>od :silent :!cygstart '%:p:h:8'<CR>
endif
nnoremap <Leader>xp :!C:/Python33/python.exe %:p:8<CR>

if has("gui_running")
	" Unbind ALt+letter keys{{{
	silent! iunmap a
	silent! iunmap b
	silent! iunmap c
	silent! iunmap d
	silent! iunmap e
	silent! iunmap f
	silent! iunmap g
	silent! iunmap h
	silent! iunmap i
	silent! iunmap j
	silent! iunmap k
	silent! iunmap l
	silent! iunmap m
	silent! iunmap n
	silent! iunmap o
	silent! iunmap p
	silent! iunmap q
	silent! iunmap r
	silent! iunmap s
	silent! iunmap t
	silent! iunmap u
	silent! iunmap v
	silent! iunmap w
	silent! iunmap x
	silent! iunmap y
	silent! iunmap z
	silent! iunmap [1~
	silent! iunmap [4~
	" }}}
endif
" Mappings }}}

"==================FUNCTIONS ====================
" VsVim has trouble parsing this. Moved down here so it would source all the mappings
function! s:escape()
	silent! .g/^\s*$/d
endfunction

" Fix trailing spaces
function! s:deleteTrailingSpaces()
	let l:winview = winsaveview()
	%s/\s\+$//e
	call winrestview(l:winview)
endfunction

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

fun! s:toggleBackground()
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
" if has("gui_running")
" 	let g:airline_powerline_fonts=1
" endif

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#whitespace#checks = [ 'trailing' ]

" Commentary
autocmd FileType autohotkey setlocal commentstring=;%s
autocmd FileType actionscript setlocal commentstring=//%s

" YouCompleteMe
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" if has("win32")
" 	let g:ycm_path_to_python_interpreter = 'D:/Python27/pythonw.exe'
" endif
" if !has("gui_running")
	let g:loaded_youcompleteme = 1
" endif

"Syntastic
let g:syntastic_enable_signs = 0

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

" Tabularize
nnoremap <leader>aa :Tabularize /=<CR>
vnoremap <leader>aa :Tabularize /=<CR>

nnoremap <Leader>js :%s /\n//<CR>:%s /\(nA\)/ \1\r/g<CR>

" Ultisnips
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

let g:UltiSnipsExpandTrigger = '<Tab>'
" let g:UltiSnipsListSnippets = '<C-b>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
inoremap <expr> <CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"

" Neocomplete {{{
let g:neocomplete#enable_at_startup=1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Define keyword.
" if !exists('g:neocomplete#keyword_patterns')
" 	let g:neocomplete#keyword_patterns = {}
" endif
" let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
" 	return neocomplete#close_popup() . "\<CR>"
" 	" For no inserting <CR> key.
" 	"return pumvisible() ? neocomplete#close_popup() : "\<CR>"
" endfunction
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><Tab>
" 		\ neocomplete#complete_common_string() != '' ?
" 		\   neocomplete#complete_common_string() :
" 		\ pumvisible() ? "\<C-n>" : "\<Tab>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1
" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1
" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" }}}

