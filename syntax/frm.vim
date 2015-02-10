if exists("b:current_syntax")
  finish
endif

setlocal iskeyword=@,48-58,_,192-255

syntax case ignore
syn match sgNumber '[-+]\?\d\+'
syn match sgHitboxTypeHit '\<0' nextgroup=sgHitboxCoord contained skipwhite
syn match sgHitboxTypeHurt '\<1' nextgroup=sgHitboxCoord contained skipwhite
syn match sgHitboxTypeCollision '\<2' nextgroup=sgHitboxCoord contained skipwhite
syn match sgHitboxCoord '[-+]\?\d\+' nextgroup=sgHitboxCoord contained skipwhite
syn match sgComment '#.*$'

syn region sgPointsBlock matchgroup=sgMainBlock start="\<Points:" end="\[end\]" fold transparent
syn region sgHitboxBlock matchgroup=sgMainBlock start="\<Hitbox:" end="\[end\]" fold transparent contains=sgHitboxTypeHurt,sgHitboxTypeHit,sgHitboxTypeCollision,sgComment
syn keyword sgCenterKeywords Center:

hi link sgNumber number
hi link sgCenterKeywords string
hi sgHitboxTypeHit guifg=#DD0000 guibg=#D2B0B0
hi sgHitboxTypeHurt guifg=#008A00 guibg=#CFDACF
hi sgHitboxTypeCollision guifg=#00008A guibg=#CFCFDA
hi link sgHitboxCoord number
hi link sgComment comment
hi link sgMainBlock string

let b:current_syntax = "frm"
