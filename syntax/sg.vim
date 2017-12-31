if exists("b:current_syntax")
  finish
endif

setlocal iskeyword=@,48-58,_,192-255
" setlocal dictionary+=~/skullgirl.api

" syntax case ignore
syn match sgNumber '\<\d\+'
syn match sgNumber '\<[-+]\d\+'
syn match sgString '".*"'
syn match sgMotionDir '\<\([NBFUD]\|UB\|UF\|DB\|DF\)\>\((L)\)\='
syn keyword sgMotionDir Jab Strong Fierce Short Forward RH P PP PPP K KK KKK
syn match sgCodeBoolean '+'
syn keyword sgControl If Else EndIf
syn keyword sgStateTags ResetComboMeter Attack
syn match sgFrameTags 'Skipped\s*=\s*1'
syn keyword sgFrameTags EndHit NoExtent EndSprite ResetCombo Attack ComboHit
syn match sgComment '#.*$'
syn keyword sgFrameKeywords Number: Repeats: contained
syn keyword sgSpriteKeywords Name: MagicType: Palette: PalMap: HalfSizeArt: HalfResNormals: HasShadow Selectable Start: Thrown: AssistState: SoundFX: Include: Alias: DamageHandler: SoundHandler: AllStateFramesExternal:
syn keyword sgConstants SOUND_RESTART SoundFlagAlwaysPlay
syn keyword sgConstants PhysicsNone PhysicsLock PhysicsAir PhysicsGround PhysicsBoth
syn keyword sgConstants HighHitAnim MidHitAnim LowHitAnim TripAnim TechableSprawlAnim TechableKnockdownAnim SprawlAnim KnockdownAnim FloorbounceAnim WallbounceAnim SlidingAnim CrumpleAnim StaggerAnim Snapout1Anim Snapout2Anim HardFrontAnim HardBackAnim ToStandAnim LaunchedAnim AllHits
syn keyword sgConstants StateAir StateGround FacingLeft FacingRight mera Shake CamShakeTiny CamShakeLight CamShakeMedium CamShakeHeavy CamShakeSuperHeavy CamShakeUltraHeavy
syn keyword sgConstants CanHitAllies CanBeHitByAllies CannotHitEnemies CannotBeHitByEnemies ReportOnly Unthrowable SetAttackerOnHit IgnoreParentSuperFlash IgnoreAllSuperFlashes UseLeaderPaletteFx StealLeaderThrowVictim UseThrowerHitboxes ExternalAssistLock MuteMusic WantCamControl WantCamVisible
syn keyword sgConstants CamBehaveLeftWall CamBehaveRightWall BlendModeNormal BlendModeSgAdd BlendModeAdd
syn keyword sgConstants None LowHit HighHit MidHit ThrowHit AlwaysHit ProjectileHit AllHits SpriteTypeNone SpriteTypeProjectile SpriteTypeNonprojectile
syn keyword sgFunctions atLeast atMost setBit clearBit hasBits notHasBits Max Min atan2 IfNonzero IfZero Power PalColor Equals NotEqual LessThan GreaterThan
syn keyword sgFunctions Random int abs sin cos victimPtX victimPtY default sqrt Print Track Untrack soundLoopStart soundLoopEnd soundStart soundFade

syn cluster sgCodeBlock contains=sgNumber,sgString,sgControl,sgComment,sgConstants,sgFunctions
syn cluster sgAniFrameBlock contains=sgProjectileBlock,sgHitInfoBlock,sgFrameKeywords,sgFrameTags,@sgCodeBlock
syn cluster sgMotionBoolean contains=sgMotionDir,sgCodeBoolean,sgComment

syn region sgFramesBlock matchgroup=sgMainBlock start="\<Frames:" end="\[end\]" fold transparent
syn region sgOrderBlock matchgroup=sgMainBlock start="\<Order:" end="\[end\]" fold transparent contains=sgSingleFrameBlock,sgComment
syn region sgAllFramesBlock matchgroup=sgMainBlock start="\<AllFrames:" end="\[end\]" fold transparent contains=sgModifierBlock,sgNumber,sgString,sgControl,sgComment,sgHitInfoBlock
syn region sgAllFramesEndBlock matchgroup=sgMainBlock start="\<AllFramesEnd:" end="\[end\]" fold transparent contains=@sgCodeBlock
syn region sgDefaultsBlock matchgroup=sgMainBlock start="\<Defaults:" end="\[end\]" fold transparent contains=@sgCodeBlock
syn region sgEndSpriteBlock matchgroup=sgMainBlock start="\<EndSprite:" end="\[end\]" fold transparent contains=sgControl,sgNumber,sgString,sgComment
syn region sgAllStateFramesBlock matchgroup=sgMainBlock start="\<AllStateFrames:" end="\[end\]" fold transparent contains=@sgCodeBlock
syn region sgProjectilesBlock matchgroup=sgMainBlock start="\<Projectiles:" end="\[end\]" fold transparent contains=sgNumber,sgString,sgComment
syn region sgGroupsBlock matchgroup=sgMainBlock start="\<Groups:" end="\[end\]" fold transparent contains=sgNumber,sgString,sgComment,sgSingleGroupBlock
syn region sgStatesBlock matchgroup=sgMainBlock start="\<States:" end="\[end\]" fold transparent contains=sgNumber,sgString,sgComment,sgSingleStateBlock
syn region sgModifierBlock matchgroup=sgSynModifierBlock start="\<Modifier:" end="\[end\]" fold transparent contains=@sgAniFrameBlock
syn region sgSingleGroupBlock matchgroup=sgInnerBlock start="\<Group:" end="\[end\]" fold transparent contains=@sgMotionBoolean,sgMotionConditionBlock,sgComment
syn region sgSingleStateBlock matchgroup=sgInnerBlock start="\<State:" end="\[end\]" fold transparent contains=sgMotionLine,sgTagsLine,sgStateTags,sgTransitionBlock,sgOnEnter,sgOnExit,sgMotionConditionBlock,sgStateOnEnterBlock,sgStateOnExitBlock,sgComment
syn region sgMotionLine matchgroup=sgLineStart start="\<Motion:" end="$" fold transparent contains=@sgMotionBoolean
syn region sgTagsLine matchgroup=sgLineStart start="\<Tags:" end="$" fold transparent contains=sgComment
syn region sgTransitionBlock matchgroup=sgLeafBlock start="\<Transitions:" end="\[end\]" fold transparent contains=sgComment
syn region sgOnEnter matchgroup=sgLeafBlock start="\<OnEnter:" end="\[end\]" fold transparent contains=sgComment
syn region sgOnExit matchgroup=sgLeafBlock start="\<OnExit:" end="\[end\]" fold transparent contains=sgComment
syn region sgMotionConditionBlock matchgroup=sgLeafBlock start="\<MotionConditions:" end="\[end\]" fold transparent contains=sgComment,sgNumber,sgString,sgControl
syn region sgStateOnEnterBlock matchgroup=sgLeafBlock start="\<OnEnter:" end="\[end\]" fold transparent contains=sgComment,sgNumber,sgString,sgControl
syn region sgStateOnExitBlock matchgroup=sgLeafBlock start="\<OnExit:" end="\[end\]" fold transparent contains=sgComment,sgNumber,sgString,sgControl
syn region sgSingleFrameBlock matchgroup=sgInnerBlock start="\<Frame:" end="\[end\]" fold transparent contains=sgModifierBlock,@sgAniFrameBlock
syn region sgProjectileBlock matchgroup=sgLeafBlock start="\<Projectile:" end="\[end\]" fold transparent contains=sgNumber,sgString,sgComment
syn region sgHitInfoBlock matchgroup=sgLeafBlock start="\<NewHit:" end="\[end\]" fold transparent contains=sgHitInfoAirBlock,sgHitInfoGroundBlock,sgNumber,sgString,sgComment
syn region sgHitInfoAirBlock matchgroup=sgInnerBlock start="\<Air:" end="\[end\]" fold transparent contains=sgNumber,sgString,sgComment
syn region sgHitInfoGroundBlock matchgroup=sgInnerBlock start="\<Ground:" end="\[end\]" fold transparent contains=sgNumber,sgString,sgComment

hi link sgNumber number
hi link sgString String
hi link sgMotionDir boolean
hi link sgCodeBoolean number
hi link sgComment comment
hi link sgSpriteKeywords type
hi link sgFrameKeywords macro
hi link sgControl operator
hi link sgStateTags Keyword
hi link sgFrameTags Keyword
hi link sgMainBlock string
hi link sgInnerBlock function
hi link sgLeafBlock identifier
hi link sgSynModifierBlock boolean
hi link sgConstants Type
hi link sgFunctions Function

let b:current_syntax = "sg"
