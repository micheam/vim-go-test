if exists("b:current_syntax")
    finish
endif

syntax keyword GoTestPass PASS
syntax keyword GoTestFail FAIL

highlight GoTestPASS
            \ term=bold,reverse 
            \ cterm=bold ctermfg=10 ctermbg=NONE
            \ gui=bold guifg=#00af00 guibg=NONE

highlight GoTestFail
            \ term=bold,reverse 
            \ cterm=bold ctermfg=9 ctermbg=NONE
            \ gui=bold guifg=#ff0000 guibg=NONE

let b:current_syntax="gotest"
