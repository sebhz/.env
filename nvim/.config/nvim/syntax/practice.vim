" Vim syntax file
" Language:	Lauterbach PRACTICE script
" Filenames:	*.cmm
" For vim version 5.x: Clear all syntax items
" For vim version 6.x: Quit when a syntax file was already loaded

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Special characters "
syn match cmmSpecial    "\\." contained
syn match cmmMacroString "&\w\+"
syn match cmmLabelString "^\w\+:"
syn match cmmArgString "%\w\+"

syn region cmmComment   start=";" end="$"
syn region cmmComment   start="//" end="$"

syn region cmmString start=+"+ skip=+\\"+ end=+"+ contains=cmmSpecial

syn case ignore
syn keyword cmmFunc STOP END CONTinue DO ENDDO RUN GOSUB RETURN GOTO JUMPTO
syn keyword cmmFunc IF ELSE WHILE RPT RePeaT ON GLOBALON WAIT
syn keyword cmmFunc GLOBAL LOCAL PRIVATE
syn keyword cmmFunc ENTRY
syn keyword cmmFunc PRINT BEEP ENTER INKEY
syn keyword cmmFunc OPEN CLOSE READ WRITE APPEND
syn case match

" numbers, from c.vim

" integer number, or floating point number without a dot and with "f".
syn case    ignore
syn match   cmmNumber	"\<[0-9]\+\(u\=l\=\|lu\|f\)\>"

" floating point number, with dot, optional exponent
syn match   cmmFloat	"\<[0-9]\+\.[0-9]*\(e[-+]\=[0-9]\+\)\=[fl]\=\>"

" floating point number, starting with a dot, optional exponent
syn match   cmmFloat	"\.[0-9]\+\(e[-+]\=[0-9]\+\)\=[fl]\=\>"

" floating point number, without dot, with exponent
syn match   cmmFloat	"\<[0-9]\+e[-+]\=[0-9]\+[fl]\=\>"

" hex number
syn match   cmmNumber	"\<0x[0-9a-f]\+\(u\=l\=\|lu\)\>"
syn case    match


" ---- Define the default highlighting ---- "
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cmm_syntax_inits")
  if version < 508
    let did_cmm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cmmComment		Comment
  HiLink cmmFunc        Identifier
  HiLink cmmString      String
  HiLink cmmNumber      Number
  HiLink cmmFloat       Float
  HiLink cmmLabelString Type 
  HiLink cmmMacroString Macro
  HiLink cmmArgString   String
endif

let b:current_syntax = "practice"
