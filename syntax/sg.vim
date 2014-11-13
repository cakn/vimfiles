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

syn region sgFramesBlock matchgroup=sgMainBlock start="\<Frames:" end="\[end\]" fold transparent
syn region sgOrderBlock matchgroup=sgMainBlock start="\<Order:" end="\[end\]" fold transparent contains=sgSingleFrameBlock,sgComment
syn region sgAllFramesBlock matchgroup=sgMainBlock start="\<AllFrames:" end="\[end\]" fold transparent contains=sgModifierBlock,sgNumber,sgCharProperties,sgComment
syn region sgDefaultsBlock matchgroup=sgMainBlock start="\<Defaults:" end="\[end\]" fold transparent contains=sgDefaultsKeywords,sgNumber,sgComment
syn region sgProjectilesBlock matchgroup=sgMainBlock start="\<Projectiles:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment
syn region sgGroupsBlock matchgroup=sgMainBlock start="\<Groups:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment,sgSingleGroupBlock
syn region sgStatesBlock matchgroup=sgMainBlock start="\<States:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment,sgSingleStateBlock
syn region sgModifierBlock matchgroup=sgLeafBlock start="\<Modifier:" end="\[end\]" fold transparent
syn region sgSingleGroupBlock matchgroup=sgInnerBlock start="\<Group:" end="\[end\]" fold transparent
syn region sgSingleStateBlock matchgroup=sgInnerBlock start="\<State:" end="\[end\]" fold transparent contains=sgTransitionBlock
syn region sgTransitionBlock matchgroup=sgLeafBlock start="\<Transitions:" end="\[end\]" fold transparent
syn region sgSingleFrameBlock matchgroup=sgInnerBlock start="\<Frame:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment
syn keyword sgFrameKeywords Number: Repeats: contained
syn keyword sgSpriteKeywords Name: Palette: PalMap: HalfSizeArt: HalfResNormals: HasShadow Selectable Start: Thrown: AssistState: SoundFX: Include:
syn keyword sgDefaultsKeywords XScale YScale Lifebar RedLife DamageMult AssistDmgMod ThrowTechTime TotalStun Friction Weight ChainLv AirDashLockout DashesLeft JumpsLeft OncePerJumpAll PreblockDistance

" syn keyword sgBlockStart Modifier: Frames: AllFrames: Order:
" syn keyword sgFrame Frame:

" hi link sgBlockStart function
" hi link sgFrame identifier
hi link sgNumber number
hi link sgComment comment
hi link sgSpriteKeywords macro
hi link sgFrameKeywords macro
hi link sgDefaultsKeywords macro
hi link sgCharProperties operator
hi link sgMainBlock string
hi link sgInnerBlock function
hi link sgLeafBlock identifier

let b:current_syntax = "sg"
