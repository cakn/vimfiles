if exists("b:current_syntax")
  finish
endif

setlocal iskeyword=@,48-58,_,192-255
setlocal dictionary+=~/skullgirl.api

syntax case ignore
syn match sgNumber '\<\d\+'
syn match sgNumber '\<[-+]\d\+'
syn keyword sgCharProperties XPos YPos XVel YVel FacingDir
syn match sgComment '#.*$'

syn region sgFramesBlock matchgroup=string start="Frames:" end="\[end\]" fold transparent
syn region sgModifierBlock matchgroup=function start="Modifier:" end="\[end\]" fold transparent
syn region sgOrderBlock matchgroup=string start="Order:" end="\[end\]" fold transparent contains=sgSingleFrameBlock,sgComment
syn region sgAllFramesBlock matchgroup=string start="AllFrames:" end="\[end\]" fold transparent contains=sgModifierBlock,sgNumber,sgCharProperties,sgComment
syn region sgSingleFrameBlock matchgroup=function start="Frame:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment
syn keyword sgFrameKeywords Number: Repeats: contained
" syn keyword sgBlockStart Modifier: Frames: AllFrames: Order:
" syn keyword sgFrame Frame:

" hi link sgBlockStart function
" hi link sgFrame identifier
hi link sgNumber number
hi link sgComment comment
hi link sgFrameKeywords macro
hi link sgFramesBlock function
hi link sgCharProperties Operator

let b:current_syntax = "sg"
