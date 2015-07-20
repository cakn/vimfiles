if exists("b:current_syntax")
  finish
endif

setlocal iskeyword=@,48-58,_,192-255
setlocal dictionary+=~/skullgirl.api

syntax case ignore
syn match sgNumber '\<\d\+'
syn match sgNumber '\<[-+]\d\+'
syn keyword sgCharProperties XPos YPos XVel YVel FacingDir XScale YScale Lifebar RedLife DamageMult AssistDmgMod ThrowTechTime TotalStun Friction Weight ChainLv AirDashLockout DashesLeft JumpsLeft OncePerJumpAll PreblockDistance
syn match sgComment '#.*$'
syn keyword sgFrameKeywords Number: Repeats: Repeat: contained
syn keyword sgSpriteKeywords Name: Palette: PalMap: HalfSizeArt: HalfResNormals: HasShadow Selectable Start: Thrown: AssistState: SoundFX: Include:

syn region sgFramesBlock matchgroup=sgMainBlock start="\<Frames:" end="\[end\]" fold transparent
syn region sgOrderBlock matchgroup=sgMainBlock start="\<Order:" end="\[end\]" fold transparent contains=sgSingleFrameBlock,sgComment
syn region sgAllFramesBlock matchgroup=sgMainBlock start="\<AllFrames:" end="\[end\]" fold transparent contains=sgModifierBlock,sgNumber,sgCharProperties,sgComment,sgHitInfoBlock
syn region sgDefaultsBlock matchgroup=sgMainBlock start="\<Defaults:" end="\[end\]" fold transparent contains=sgCharProperties,sgNumber,sgComment
syn region sgEndSpriteBlock matchgroup=sgMainBlock start="\<EndSprite:" end="\[end\]" fold transparent contains=sgCharProperties,sgNumber,sgComment
syn region sgProjectilesBlock matchgroup=sgMainBlock start="\<Projectiles:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment
syn region sgGroupsBlock matchgroup=sgMainBlock start="\<Groups:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment,sgSingleGroupBlock
syn region sgStatesBlock matchgroup=sgMainBlock start="\<States:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment,sgSingleStateBlock
syn region sgModifierBlock matchgroup=sgLeafBlock start="\<Modifier:" end="\[end\]" fold transparent
syn region sgSingleGroupBlock matchgroup=sgInnerBlock start="\<Group:" end="\[end\]" fold transparent contains=sgMotionConditionBlock,sgComment
syn region sgSingleStateBlock matchgroup=sgInnerBlock start="\<State:" end="\[end\]" fold transparent contains=sgTransitionBlock,sgMotionConditionBlock,sgStateOnEnterBlock,sgStateOnExitBlock,sgComment
syn region sgTransitionBlock matchgroup=sgLeafBlock start="\<Transitions:" end="\[end\]" fold transparent contains=sgComment
syn region sgMotionConditionBlock matchgroup=sgLeafBlock start="\<MotionConditions:" end="\[end\]" fold transparent contains=sgComment,sgNumber,sgCharProperties
syn region sgStateOnEnterBlock matchgroup=sgLeafBlock start="\<OnEnter:" end="\[end\]" fold transparent contains=sgComment,sgNumber,sgCharProperties
syn region sgStateOnExitBlock matchgroup=sgLeafBlock start="\<OnExit:" end="\[end\]" fold transparent contains=sgComment,sgNumber,sgCharProperties
syn region sgSingleFrameBlock matchgroup=sgInnerBlock start="\<Frame:" end="\[end\]" fold transparent contains=sgProjectileBlock,sgModifierBlock,sgHitInfoBlock,sgFrameKeywords,sgNumber,sgComment,sgCharProperties
syn region sgProjectileBlock matchgroup=sgLeafBlock start="\<Projectile:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment
syn region sgHitInfoBlock matchgroup=sgLeafBlock start="\<NewHit:" end="\[end\]" fold transparent contains=sgHitInfoAirBlock,sgHitInfoGroundBlock,sgFrameKeywords,sgNumber,sgComment
syn region sgHitInfoAirBlock matchgroup=sgInnerBlock start="\<Air:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment
syn region sgHitInfoGroundBlock matchgroup=sgInnerBlock start="\<Ground:" end="\[end\]" fold transparent contains=sgFrameKeywords,sgNumber,sgComment

" syn keyword sgBlockStart Modifier: Frames: AllFrames: Order:
" syn keyword sgFrame Frame:

" hi link sgBlockStart function
" hi link sgFrame identifier
hi link sgNumber number
hi link sgComment comment
hi link sgSpriteKeywords macro
hi link sgFrameKeywords macro
hi link sgCharProperties operator
hi link sgMainBlock string
hi link sgInnerBlock function
hi link sgLeafBlock identifier

let b:current_syntax = "sg"
