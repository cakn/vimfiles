set nocompatible

" Removes all autocmds
" autocmd!

let g:pathogen_disabled = []
" call add( g:pathogen_disabled, 'YouCompleteMe' )
call add( g:pathogen_disabled, 'vimproc' )
call add( g:pathogen_disabled, 'unite' )
call add( g:pathogen_disabled, 'unite-outline' )

execute pathogen#infect()

filetype plugin indent on
syntax enable

function! s:getVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! s:pythonSelectedTextPasteAbove(module_name)
  let visual_text = <SID>getVisualSelection()
python << EOF
import cpp.vim_wrapper
import vim
# reload(cpp.vim_wrapper)
# cpp.vim_wrapper.reloadModules = True
module_name = vim.eval("a:module_name")
visual_text = vim.eval("visual_text")
cpp.vim_wrapper.vimMainAppendSelection(module_name, visual_text)
EOF
endfunction

function! s:runPython()
  let execute_string = ""
  if exists("b:python_file")
    let execute_string = "Make " . "\"" . b:python_file . "\""
  elseif exists("g:python_file")
    let execute_string =  "Make " . "\"" . g:python_file . "\""
  else
    let execute_string =  "Make \"%:p\""
  endif
  if exists("b:python_args")
    let execute_string = execute_string . " " . b:python_args
  elseif exists("g:python_args")
    let execute_string =  execute_string . " " . g:python_args
  endif
  execute execute_string
endfunction

" Autocommands {{{
" Autosource vimrc
" autocmd bufwritepost .vimrc source $MYVIMRC

" Use augroup to prevent vim from duplicating autocmds on when re-sourcing
augroup main_augroup
  autocmd!
  " Restore last cursor position of file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Enable marker folds for .vimrc files and shell files
  autocmd FileType vim,sh setlocal foldmethod=marker

  " Disable autocomment
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Highlight word cursor is on
  autocmd CursorMoved * exe printf('match CursorSelect /\V\<%s\>/', escape(expand('<cword>'), '/\'))

  " Allow Enter to quick jump to error in quickfix windows
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd BufReadPost quickfix,location set nobuflisted
  autocmd BufReadPost quickfix,location nnoremap <buffer> bn <nop>
  autocmd BufReadPost quickfix,location nnoremap <buffer> bp <nop>

  autocmd BufNewFile,BufRead *.jsfl set filetype=javascript
augroup END

augroup python_augroup
  autocmd!
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> <F5> :call <SID>runPython()<CR>
  autocmd BufNewFile,BufRead *.py compiler python
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> go :YcmCompleter GoTo<CR>
augroup END

augroup cpp_augroup
  autocmd!
  autocmd BufNewFile,BufRead *{.cpp,.h} nnoremap <buffer> <F5> :setlocal makeprg=cmake\ --build\ D:/dev/proj/SoundReader/build\ --config\ Debug\ --\ /property:GenerateFullPaths=true\ /m<CR>:Make<CR>
  autocmd BufNewFile,BufRead *{.cpp,.h} nnoremap <buffer> <F6> :Dispatch "D:/dev/proj/SoundReader/bin/Debug/SoundReader.exe"<CR>
  autocmd BufNewFile,BufRead *{.cpp,.h} nnoremap <buffer> <S-Space> :YcmCompleter GetType<CR>

  " Cpp ctor stub by highlighting the member vars
  autocmd BufNewFile,BufRead *{.cpp,.h} command! -range Ctor :call <SID>pythonSelectedTextPasteAbove("cpp.ctor_stub")<CR>
  autocmd BufNewFile,BufRead *{.cpp,.h} command! -range Opeq :call <SID>pythonSelectedTextPasteAbove("cpp.stub_opeq")<CR>
augroup END

" }}}

cd D:/dev/proj


" Settings {{{
" Prevent exploits
set nomodeline

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
  " highlight CursorSelect ctermbg=0 guibg=#333333

  " colorscheme Tomorrow
  " highlight CursorSelect ctermbg=0 guibg=#EAEAEA

  let g:molokai_original=1
  " let g:rehash256=1
  set background=dark
  colorscheme molokai
  highlight CursorSelect ctermbg=0 guibg=#444444
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
" Tab length for >> indenting
set shiftwidth=2
" Tab distance when inserting a tab
set softtabstop=2
" Width that a \t is interpreted
set tabstop=2
set expandtab
nnoremap <Leader>t2 :set shiftwidth=2 softtabstop=2 tabstop=2<CR>
nnoremap <Leader>t4 :set shiftwidth=4 softtabstop=4 tabstop=4<CR>
" Stop # from being unindentable
set indentkeys-=:,0#
set cinkeys-=0#

" Disable textwidth so vim doesn't autobreak long lines
set textwidth=0

set wildmenu
set wildmode=longest:full

set completeopt=longest,menu
" No preview scratch window that constantly moves the text around
set completeopt-=preview

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

set cmdheight=1

set nostartofline

set mouse=a

set listchars=tab:>-

" set foldmethod=syntax
" set foldcolumn=2
" set foldopen=block,hor,mark,percent,quickfix,search,tag,undo,jump

" Fast terminal
set tf

" Match <>
set matchpairs+=<:>

set lazyredraw

set timeoutlen=1000
augroup insert_timeout_augroup
  autocmd!
  autocmd InsertEnter * :setlocal timeoutlen=250
  autocmd InsertLeave * :setlocal timeoutlen=1000
augroup END

set virtualedit=block,onemore

"Set encoding up here to avoid problems with alt
set encoding=utf-8

set sessionoptions+=winpos
set sessionoptions+=resize

function! NeatFoldText()
  " let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let line = ' ' . substitute(getline(v:foldstart), '^\(\s*\)\(\S.*\)', '\2', '') . ' '
  let line_leading_space = substitute(getline(v:foldstart), '^\(\s*\)\S.*', '\1', '')
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart(line_leading_space . '+' . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

" Use forward slash instead of backslash
" Don't use on windows. cmd is inconsistent with its handling of forward slashes
" Sometimes it works sometimes it doesn't
" set shellslash

" Settings }}}


" Text Objects {{{

function! s:PythonTextObject(module_name, inner)
python << EOF
import cpp.vim_wrapper
import vim
#reload(cpp.vim_wrapper)
module_name = vim.eval("a:module_name")
inner = int(vim.eval("a:inner")) != 0
cpp.vim_wrapper.vimMainTextObject(module_name, inner=inner)
EOF
endfunction

function! s:TextObject_CppType()
  call <SID>PythonTextObject("cpp.text_object_type", 1)
endfunction

function! s:TextObject_CppFunction()
  call <SID>PythonTextObject("cpp.text_object_function", 1)
endfunction

function! s:TextObject_CppParamInner()
  call <SID>PythonTextObject("cpp.text_object_param", 1)
endfunction

function! s:TextObject_CppParamOutter()
  call <SID>PythonTextObject("cpp.text_object_param", 0)
endfunction

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
silent! ounmap ,w
silent! ounmap ,b
silent! ounmap ,e
silent! nunmap ,w
silent! nunmap ,b
silent! nunmap ,e

onoremap y l

" word including . and : and ->
vnoremap aL :<C-U>let @z=@/<CR>
      \?\([a-zA-Z0-9_\.:\(\->\)]*\%#[a-zA-Z0-9_\.:\(\->\)]*\)?e<CR>
      \m<
      \/\([a-zA-Z0-9_\.:\(\->\)]*\%#[a-zA-Z0-9_\.:\(\->\)]*\)<CR>
      \m>
      \:let @/=@z<CR>
      \gv
onoremap L :normal vaL<CR>

" param text object
" vnoremap aj <Esc>:let @z=@/<CR><Left>?[(,]?e-1<CR>v/[,)]<CR>o<Esc>/\(\%V[(,][^,]*\ze)\)\\|\(\%V[,(]\zs[^,]*,\)<CR>v/\(\%V[(,][^,]\{-}\ze\s*)\)\\|\(\%V[^,]*,\)/e<CR>:<C-U>let @/=@z<CR>gv
" vnoremap ij <Esc>:let @z=@/<CR><Left>?[(,]?e<CR>v/[,)]<CR>o<Esc>/\(\s*\zs[^,]*\ze)\)\\|\(\s*\zs[^(,]*\ze,\)/s<CR>v/\(\s*[,)]\)/s<CR><Left>:<C-U>let @/=@z<CR>gv
" onoremap aj :normal vaj<CR>
" onoremap ij :normal vij<CR>
" onoremap j :normal vij<CR>

onoremap j :call <SID>TextObject_CppParamInner()<CR>
onoremap J :call <SID>TextObject_CppParamOutter()<CR>

onoremap k iw
onoremap K iW
onoremap ak aw
onoremap ik iw
onoremap aK aW
onoremap iK iW
" onoremap w iw
" onoremap W iW
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

onoremap n :call <SID>TextObject_CppType()<CR>
onoremap u :call <SID>TextObject_CppFunction()<CR>


" call textobj#user#plugin('php', {
" \   'code': {
" \     'pattern': ['\[+-*/%\]', '\[+-*/%\]'],
" \     'select-a': 'aP',
" \     'select-i': 'iP',
" \   },
" \ })


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
nnoremap ; :
vnoremap ; :
nnoremap , ;
nnoremap : ,
nnoremap q; q:
nnoremap @; @:

" Swap jump to marks
nnoremap ' `
nnoremap ` '

" Swap 0 and ^
nnoremap 0 ^
nnoremap ^ 0

" Move left easier
nnoremap s b
nnoremap <S-S> B
vnoremap s b
" Move left end of word
nnoremap gr ge
nnoremap gR gE
" Move right beginning of word
nnoremap r w
nnoremap R W
nnoremap <A-r> R
nnoremap <C-Y> <C-R>

" Make marks harder
nnoremap <A-m> m
nnoremap m m
" ctrl-r sets register
nnoremap <C-R> "

"surround quote with "
nnoremap " viw<ESC>`>a"<ESC>`<i"<ESC>

" Buffer moving
nnoremap bn :bn<CR>
nnoremap bp :bp<CR>
nnoremap bd :bn\|bd #<CR>
nnoremap bb :b#<CR>

" Windows
function! s:MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! s:DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

nnoremap w <C-W>
nnoremap wtl :call <SID>MarkWindowSwap()<CR><C-W>l:call <SID>DoWindowSwap()<CR>
nnoremap wth :call <SID>MarkWindowSwap()<CR><C-W>h:call <SID>DoWindowSwap()<CR>
" nnoremap wtl <C-w>r
" nnoremap wth <C-w>R

" Tag moving
nnoremap go g<C-]>
" Tag open in split
nnoremap wgol :let word=expand("<cword>")<CR><C-W>l:exe "tjump" word<CR>
nnoremap wgoh :let word=expand("<cword>")<CR><C-W>h:exe "tjump" word<CR>

" File open in split
nnoremap wfl <C-W>f:call <SID>MarkWindowSwap()<CR><C-W>l:call <SID>DoWindowSwap()<CR><C-W>h:close<CR><C-W>l
nnoremap wfh <C-W>f:call <SID>MarkWindowSwap()<CR><C-W>h:call <SID>DoWindowSwap()<CR><C-W>l:close<CR><C-W>h
nnoremap wfj <C-W>f:call <SID>MarkWindowSwap()<CR><C-W>j:call <SID>DoWindowSwap()<CR><C-W>k:close<CR><C-W>j
nnoremap wfk <C-W>f:call <SID>MarkWindowSwap()<CR><C-W>k:call <SID>DoWindowSwap()<CR><C-W>j:close<CR><C-W>k

" Ctrl+S saving
nnoremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <Esc>:call <SID>escape()<CR>:update<CR>
nnoremap gs :update<CR>

" Ctrl+c jk comment and copy line
nnoremap <C-C>j mzyyp`z:normal gcc<CR>j
nnoremap <C-C>k mzyyP`z:normal gcc<CR>k
vnoremap <C-C>j ygv:normal gcc<CR>`>p
vnoremap <C-C>k ygv:normal gcc<CR>`<P
" Shift+Alt copy line
nnoremap <A-J> mz"zyy"zp`zj
nnoremap <A-K> mz"zyy'zp`z
inoremap <A-J> <Esc>"zyy"zp`^<Down>i
inoremap <A-K> <Esc>"zyy"zP`^<Up>i

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
" Last delete/change paste
nnoremap pd "1p
nnoremap pc "+p
nnoremap pp p
inoremap <C-P>c <C-O>"+P
inoremap <C-P><C-C> <C-O>"+P
inoremap <C-P>y <C-O>"0P
inoremap <C-P><C-Y> <C-O>"0P
nnoremap Py "0P
nnoremap Pc "+P
nnoremap Pd "1P
nnoremap PP P

" Replace motion with last yanked
nnoremap pw "_ciw<C-R>0<Esc>
nnoremap pk "_ciw<C-R>0<Esc>
" Replace quotes
nnoremap p" "_ci"<C-R>0<Esc>
" Using param motion to replace param with last yanked
nnoremap pj :normal "_cj<CR>a<C-R>0<Esc>

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
xnoremap sj <Esc>
cnoremap sj <Esc>
" Quick save
inoremap ksf <Esc>:call <SID>escape()<CR>:update<CR>

" Copy line and increment number
nnoremap <A-a> :call <SID>IncAllNumbersInLine()<CR>
nnoremap a :call <SID>IncAllNumbersInLine()<CR>
function! s:IncAllNumbersInLine()
    execute "normal! mzyyp:s/\\d\\+/\\=(submatch(0)+1)/g\<CR>`zj"
endfunction

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
nnoremap dj :normal dJ<CR>
nnoremap dl :normal dil<CR>
" Stops vim from waiting for a command after dd
nnoremap dd dd
" Change bracket to leave space
nnoremap c) ci)<Space><Space><Left>
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
" Move a word
inoremap <C-F> <C-Left>

" Delete character in insert mode
inoremap <C-D> <Del>
" inoremap <A-r> <C-R>
" inoremap r <C-R>
" cnoremap <A-r> <C-R>

"Shift j k to move quickly up and down
nnoremap J <C-E>j<C-E>j<C-E>j
vnoremap J jjj
nnoremap K <C-Y>k<C-Y>k<C-Y>k
vnoremap K kkk
"Join and split lines
nnoremap gJ J
nnoremap gK i<CR><Esc>

"Shift H L to move to front/end of the line
nnoremap H g^
nnoremap L g$
vnoremap H g^
vnoremap L g$

" Swap [ and { to move quickly between functions
" nnoremap [ [[
" nnoremap ] ]]

nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

nnoremap >> >>
nnoremap << <<
vnoremap > >gv
vnoremap < <gv

" Shift tab to deindent
"nnoremap <S-Tab> <<
inoremap <S-Tab> <C-D>
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

"save position on visual yank
vnoremap y mzy`z

" cut visual
vnoremap x ygvx
" cut with space too
nnoremap <space> "0d

" Negate boolean variable with !
nnoremap ! :let @z=@/<CR>mzviwovi!<Esc>:s /!!=/==/e<CR>:s /!!//e<CR>:s /!true/false/Ie<CR>:s /!True/False/Ie<CR>:s /!false/true/Ie<CR>:s /!False/True/Ie<CR>:s /!==/!=/e<CR>:let @/=@z<CR>`z
nnoremap <C-!> !

" Append & in front of word
nnoremap <A-7> :let @z=@/<CR>mzviwovi&<Esc>:s /&&//e<CR>:let @/=@z<CR>`z
" Append & in back of word
nnoremap <A-9> :let @z=@/<CR>mz:call <SID>TextObject_CppType()<CR><Esc>`>a&<Esc>:let @/=@z<CR>`z
" Append * in front of word
nnoremap <A-8> :let @z=@/<CR>mzviwovi*<Esc>:s /\*\*//e<CR>:let @/=@z<CR>`z
" Append * in back of word
nnoremap <A-0> :let @z=@/<CR>mz:call <SID>TextObject_CppType()<CR><Esc>`>a*<Esc>:let @/=@z<CR>`z

" const word&
" nnoremap & mzviWva&<C-O>b<C-O>b<C-O>Bconst <C-c>
nnoremap & :call <SID>TextObject_CppType()<CR><Esc>`>a&<Esc>`<iconst <Esc>

" Turn off highlighting with <C-L> (redraw screen)
nnoremap <C-L> :nohlsearch<CR><C-L>

" To end of word in insert mode
inoremap <C-F> <Esc>ea

" Close file
nnoremap <Leader>cl :clo<CR>

" New tab
" nnoremap <Leader>tn :tabnew<CR>
" Move window to new tab
" nnoremap <Leader>bt <C-W>s<C-W>T

" Make file
nnoremap <leader>mb :wa<CR>:Make<CR>
nnoremap <Leader>mk :Make<CR>
nnoremap <Leader>md :Make debug<CR>
nnoremap <Leader>mr :Make run<CR>

" Edit vimrc, gvimrc files
nnoremap <Leader>ev :e $MYVIMRC<CR>
nnoremap <Leader>egv :e $MYGVIMRC<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>
nnoremap <Leader>sgv :so $MYGVIMRC<CR>

" Quick notes file
nnoremap <Leader>en :tabnew ~/vimNotes.txt<CR>

"Bash rc files
nnoremap <Leader>eb :tabnew ~/.vim/.bashrc<CR>
nnoremap <Leader>ebb :tabnew ~/.vim/.bashrc<CR>
nnoremap <Leader>ebi :tabnew ~/.inputrc<CR>

" File plugin files
nnoremap <Leader>efp :tabnew ~/.vim/ftplugin<CR>
nnoremap <Leader>esp :tabnew ~/.vim/syntax<CR>
nnoremap <Leader>eap :tabnew ~/.vim/after/plugin<CR>
nnoremap <Leader>ecp :tabnew ~/.vim/colors<CR>

" Add new file
nnoremap <Leader>af :e <C-R>=expand("%:p:h") . "/" <CR>

if( has("win32") || has("win32unix") )
  nnoremap <Leader>ehk :tabnew ~/Autohotkey.ahk<CR>
  nnoremap <Leader>es :e ~/_vsvimrc<CR>
endif

" Toggle background colors
nnoremap <Leader>tbg :call <SID>toggleBackground()<CR>

" Set directory to currently open file's
nnoremap <Leader>cd :cd %:h<CR>

" Insert file name
nnoremap <Leader>ifn i<C-R>=expand("%:t:r")<CR><Esc>

" Fix trailing spaces
nnoremap <Leader>dts :call <SID>deleteTrailingSpaces()<CR>

" Replace slash
vnoremap <Leader>c\/ :s$\\$/$g<CR>

" Run python on selected
nnoremap <Leader>py :.!python<CR>
" vnoremap <Leader>py yppgv:!python<CR>
vnoremap <Leader>py y`>p`[v`]:!python<CR>
command! -range Py :<line1>,<line2>!python<CR>

" Insert fold marker
nnoremap <Leader>ifo o{{{<Esc>:normal gc<CR>
nnoremap <Leader>ifc o}}}<Esc>:normal gc<CR>

" Quick fix show
nnoremap <leader>qo :botright copen<CR>
" Quick fix next
nnoremap ge :cn<CR>
nnoremap gE :cp<CR>
command! ClearQuickfixList cexpr []
" Clear and close quickfix
nnoremap <leader>qcl :ClearQuickfixList<CR>:cclose<CR>

" Quick fix do (runs command on all files in quick list)
function! s:QFDo(command)
    " Create a dictionary so that we can
    " get the list of buffers rather than the
    " list of lines in buffers (easy way
    " to get unique entries)
    let buffer_numbers = {}
    " For each entry, use the buffer number as
    " a dictionary key (won't get repeats)
    for fixlist_entry in getqflist()
        let buffer_numbers[fixlist_entry['bufnr']] = 1
    endfor
    " Make it into a list as it seems cleaner
    let buffer_number_list = keys(buffer_numbers)

    " For each buffer
    for num in buffer_number_list
        " Select the buffer
        exe 'buffer' num
        " Run the command that's passed as an argument
        exe a:command
        " Save if necessary
        update
    endfor
endfunction
command! -nargs=+ Cdo call <SID>QFDo(<q-args>)


" Find all
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif
command! -nargs=? FindAll :silent grep!<space><args><bar>botright<space>copen
nnoremap <C-F>f :Grepper<CR>

" Replace all
nnoremap <C-F>r :%s//g<Left><Left>

" ctags
command! Ctags :!ctags --fields=+iaS --extra=+q --exclude="*/build/*" --exclude="*/bin/*" --exclude=".ycm_extra_conf.py" -R

if has("win32")
  " Open directory of file in explorer
  nnoremap <silent> <Leader>od :silent :!start explorer %:p:h:8<CR>

  " Touch for windows
  command! -nargs=1 -complete=file Touch :!touch.exe <args><CR>

  " Run file
  nnoremap <Leader>xe :!start "%:p"<CR>
  nnoremap <Leader>xp :Dispatch "%:p"<CR>

  command! Cmd :!start cmd /k cd %:p:h<CR>
  command! -nargs=1 -complete=file CmdAsync :!start cmd /k <args><CR>

  " cscope
  command! -nargs=? Find :!D:/cygwin64/bin/find.exe <args>
  set cscopeprg=D:/cygwin64/bin/cscope.exe
  command! -nargs=? Cscope :!D:/cygwin64/bin/cscope.exe <args>
  nmap <F11> :Find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
    \:Cscope -b -i cscope.files -f cscope.out<CR>
    \:cscope kill -1<CR>:cscope add cscope.out<CR>
endif

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
" Syntax highlight debugging
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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

" Create directory and file at same time with command :E
function! s:MKDir(...)
    if         !a:0
           \|| isdirectory(a:1)
           \|| filereadable(a:1)
           \|| isdirectory(fnamemodify(a:1, ':p:h'))
        return
    endif
    return mkdir(fnamemodify(a:1, ':p:h'), 'p')
endfunction
command! -bang -bar -nargs=? -complete=file E :call s:MKDir(<f-args>) | e<bang> <args>

"==================PLUGINS ======================
" Swap Parameters
nnoremap <A-e> :call SwapParams("forwards")<cr>
nnoremap <A-s> :call SwapParams("backwards")<cr>

" netrw
" Default edit window number
" let g:netrw_chgwin= 1

" Clang format
nnoremap <Leader>cf :pyf D:\Program Files\LLVM\share\clang\clang-format.py<cr>
vnoremap <Leader>cf :pyf D:\Program Files\LLVM\share\clang\clang-format.py<cr>

" Airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
if has("gui_running")
  " let g:airline_powerline_fonts=1
endif

let g:airline_theme='molokai'
" Cache syntax highlighting for better speed. :AirlineRefresh clears this cache
let g:airline_highlighting_cache = 1
" Disables searching for extensions on the runtimepath during startup
let g:airline#extensions#disable_rtp_load = 1
" Load extensions manually
let g:airline_extensions = ['quickfix', 'tabline', 'whitespace', 'ycm']
" Display buffers when there's only one tab open
let g:airline#extensions#tabline#enabled=1

function! TagGenStatusLine()
  let x = gutentags#statusline()
  if strlen(x) > 0
    return '| TAGS '
  endif
  return ''
endfunction

function! AirlineInit()
  call airline#parts#define_raw('new_lines', '%3p%% | ln %-4l:%2v')
  call airline#parts#define_raw('tags', '%{TagGenStatusLine()}')
  let g:airline_section_z = airline#section#create_right(['new_lines', 'tags'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" Commentary
augroup commentary_augroup
  autocmd!
  autocmd FileType autohotkey setlocal commentstring=;%s
  autocmd FileType actionscript setlocal commentstring=//%s
  autocmd FileType cmake setlocal commentstring=#%s
  autocmd FileType cpp setlocal commentstring=//%s
augroup END

" YouCompleteMe
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<S-TAB>']
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" No warning of loading ycm_extra_conf if the file matches this
let g:ycm_extra_conf_globlist = ['D:/dev/proj/*/.ycm_extra_conf.py']

" let g:ycm_enable_diagnostic_signs = 0
let g:ycm_error_symbol = '|'
let g:ycm_warning_symbol = '|'
" if !has("gui_running")
  " let g:loaded_youcompleteme = 1
" endif

"{{{ Syntastic
" " let g:syntastic_mode_map = { 'mode': 'active',
"                            " \ 'active_filetypes': ['javascript'],
"                            " \ 'passive_filetypes': ['html'] }
" let g:syntastic_enable_signs = 0
" let g:syntastic_javascript_checkers = ['closurecompiler']
" let g:syntastic_javascript_closurecompiler_path = 'D:\\cygwin64\\home\\Kenneth\\compiler.jar'
" let g:syntastic_javascript_closurecompiler_args = '--language_in=ECMASCRIPT6'
" " let g:syntastic_javascript_closurecompiler_path = '/cygdrive/d/cygwin64/home/Kenneth/compiler.jar'

" " let g:syntastic_check_on_open = 1
" " let g:syntastic_lua_checkers = ["luacheck"]
" " let g:syntastic_lua_luacheck_args = "--no-unused-args"
" }}}

" FSwitch
nnoremap <Leader>g; :FSHere<CR>
nnoremap <Leader>gh :FSLeft<CR>
nnoremap <Leader>gsh :FSSwitchLeft<CR>
nnoremap <Leader>gl :FSRight<CR>
nnoremap <Leader>gsl :FSSwitchRight<CR>
let g:fsnonewfiles = 1
augroup mycppfiles_augroup
    autocmd!
    autocmd BufEnter *.cpp let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = 'reg:|src|include/**|'
    autocmd BufEnter *.h let b:fswitchdst  = 'cpp,cc,C' | let b:fswitchlocs = 'reg:|include[\\/][^\\/]*|src|'
augroup END

"{{{ Unite
" " let g:unite_source_rec_async_command = ['ag', '--follow',  '--nocolor',
" "                 \ '--nogroup', '--hidden', '-g', '']
" call unite#filters#matcher_default#use(['matcher_fuzzy'])

" " Change async command to exclude files if slow
" call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern', '\v\.pcx$|\.frm$|\.tlog$')
" call unite#custom#source('file_rec,file_rec/async', 'ignore_globs', ['*.pdb', '*.obj', '*.pyc', '**/build/**', '**/buildEm/**', '**/bin/**', '**/.svn/**', '**/munged/**'])

" " Search on file names only, not path
" call unite#custom#source(
"         \ 'buffer,file_rec/async,file_rec', 'matchers',
"         \ ['converter_tail', 'matcher_default'])
" call unite#custom#source(
"         \ 'buffer,file_rec/async,file_rec', 'converters',
"         \ ['converter_file_directory'])

" " nnoremap <leader>r :<C-u>UniteWithProjectDir -buffer-name=files -start-insert file_rec/async<cr>
" " nnoremap <leader>r :<C-u>Unite -buffer-name=files -start-insert file_rec/async<cr>
" nnoremap <leader>r :<C-u>Unite -buffer-name=files -start-insert file_rec<cr>
" nnoremap <leader>f :<C-u>UniteWithBufferDir -buffer-name=files -start-insert buffer file file/new directory/new<cr>
" nnoremap <leader>b :<C-u>Unite -start-insert bookmark buffer<CR>
" nnoremap <leader>d :<C-u>Unite -vertical -winwidth=35 outline<CR>

" augroup unite_augroup
"   autocmd!
"   autocmd FileType unite call s:unite_my_settings()
" augroup END
" function! s:unite_my_settings() "{{{
"   " Overwrite settings.
"   imap <buffer> sj <Plug>(unite_insert_leave)
"   nmap <buffer> sj <Plug>(unite_all_exit)
"   nmap <buffer> q <Plug>(unite_all_exit)
"   imap <buffer> <TAB> <Plug>(unite_complete)
"   nmap <buffer> J <Plug>(unite_select_next_line)
"   nmap <buffer> K <Plug>(unite_select_previous_line)<Plug>(unite_select_previous_line)<Plug>(unite_select_previous_line)
"   imap <buffer> <C-j> <Plug>(unite_select_next_line)
"   imap <buffer> <C-k> <Plug>(unite_select_previous_line)
"   imap <buffer><expr> j unite#smart_map('j', '')
"   imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
"   imap <buffer> ' <Plug>(unite_quick_match_default_action)
"   nmap <buffer> ' <Plug>(unite_quick_match_default_action)
"   imap <buffer><expr> x
"   \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
"   nmap <buffer> x <Plug>(unite_quick_match_choose_action)
"   nmap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
"   imap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
"   imap <buffer> <C-y> <Plug>(unite_narrowing_path)
"   nmap <buffer> <C-y> <Plug>(unite_narrowing_path)
"   nmap <buffer> <C-j> <Plug>(unite_toggle_auto_preview)
"   nmap <buffer> <C-r> <Plug>(unite_narrowing_input_history)
"   imap <buffer> <C-r> <Plug>(unite_narrowing_input_history)
"   map <buffer> <C-l> <Plug>(unite_redraw)
"   nmap <buffer> . <Plug>(unite_narrowing_dot)
"   imap <buffer> - ../
"   nmap <buffer> - i../
"   " nnoremap <silent><buffer><expr> l
"   " \ unite#smart_map('l', unite#do_action('default'))
"   let unite = unite#get_current_unite()
"   if unite.profile_name ==# 'search'
"     nnoremap <silent><buffer><expr> r unite#do_action('replace')
"   else
"     nnoremap <silent><buffer><expr> r unite#do_action('rename')
"   endif
"   nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
"   nnoremap <buffer><expr> S unite#mappings#set_current_filters(
"   \ empty(unite#mappings#get_current_filters()) ?
"   \ ['sorter_reverse'] : [])
"   " Runs "split" action by <C-s>.
"   imap <silent><buffer><expr> <C-s> unite#do_action('split')
" endfunction "}}}
" }}}

" Denite

" Change file_rec command.
call denite#custom#var('file_rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

call denite#custom#source(
\ 'file_rec', 'matchers', ['matcher_cpsm'])
" Change sorters.
call denite#custom#source(
\ 'file_rec', 'sorters', ['sorter_sublime'])

" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Change default prompt
call denite#custom#option('default', 'prompt', '>')

" Change ignore_globs
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.svn/', '.ropeproject/', '__pycache__/',
      \   'bin/', 'build/'])

call denite#custom#option('_', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'Function')
" call denite#custom#option('_', 'direction', 'topleft')

call denite#custom#map('insert', 'sj', '<denite:enter_mode:normal>')
call denite#custom#map('normal', 'J', '<denite:scroll_window_down_one_line>')
call denite#custom#map('normal', 'K', '<denite:scroll_window_up_one_line>')
call denite#custom#map('normal', 'w', '<C-w>')

call denite#custom#map('_', '<leader>cl', '<denite:quit>')

" Hack around windows slashes
if has("win32")
  call denite#custom#map('insert', '.', '..\')
endif

nnoremap <leader>r :<C-u>Denite file_rec<cr>
nnoremap <leader>f :<C-u>DeniteBufferDir file buffer<cr>
nnoremap <leader>b :<C-u>Denite buffer<CR>
nnoremap <leader>d :<C-u>Denite -winwidth=35 -split=vertical outline<CR>
nnoremap <leader>l :<C-u>Denite line<CR>
nnoremap <leader>g :<C-u>Denite -no-quit -resume grep<CR>

" Tabularize
" also could check lion plugin that does similiar things
nnoremap <leader>aa :Tabularize /=<CR>
vnoremap <leader>aa :Tabularize /=<CR>

" NERDTree
nnoremap <leader>e :<C-u>NERDTreeFocus<CR>
let NERDTreeIgnore=['\.pyc$', '\~$']
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeNaturalSort = 1
  let NERDTreeShowHidden = 1

" Ultisnips {{{
nnoremap <Leader>eps :UltiSnipsEdit<CR>
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
" let g:UltiSnipsExpandTrigger = '<C-b>'
" let g:UltiSnipsListSnippets = '<C-b>'
let g:UltiSnipsListSnippets = '<C-b>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
augroup ultisnips_augroup
  autocmd!
  autocmd BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
augroup END
" }}}

" Neocomplete {{{
if 0
inoremap <expr> <CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"
let g:neocomplete#enable_at_startup=0
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Define keyword.
" if !exists('g:neocomplete#keyword_patterns')
"   let g:neocomplete#keyword_patterns = {}
" endif
" let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   return neocomplete#close_popup() . "\<CR>"
"   " For no inserting <CR> key.
"   "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
" endfunction
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><Tab>
"     \ neocomplete#complete_common_string() != '' ?
"     \   neocomplete#complete_common_string() :
"     \ pumvisible() ? "\<C-n>" : "\<Tab>"
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
augroup omnifunc_augroup
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END
" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" }}}

" {{{ gutentags
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_new = 0
let g:gutentags_ctags_exclude = ['CMakeList.txt', '.ycm_extra_conf.py', 'build', 'bin', 'buildEm']

" let g:gutentags_exclude_project_root = ['/usr/local', '~/.vim']
" Default markers are already added
"`['.git', '.hg', '.bzr', '_darcs', '_darcs', '_FOSSIL_', '.fslckout']`
" let g:gutentags_project_root = ['.svn']

" TO add: status line display on tag gen
" :set statusline+=%{gutentags#statusline()}
" }}}

" {{{ easymotion
map , <Plug>(easymotion-bd-f)
nmap , <Plug>(easymotion-overwin-f)
" }}}

source $HOME/private_settings.vimrc
