" execution_history
" Version: 0.0.1
" Author: micheam
" License: TBD

let s:stack = []

function! gotest#execution_history#clear()
    let s:stack = []
endfunction

function! gotest#execution_history#add(pkg, func = v:none)
    let e = #{package: a:pkg, function: a:func}
    call add(s:stack, #{package: a:pkg, function: a:func})
endfunction

" TODO: filter_expr は (i, package, function)->bool にする
function! gotest#execution_history#list(filter_expr = v:none)
    if a:filter_expr != v:none
        return s:stack->filter(filter_expr)
    endif
    return s:stack
endfunction

function! gotest#execution_history#last()
    return s:stack[-1]
endfunction

function! gotest#execution_history#lastPackage()
    if s:stack == []
        return v:none
    endif
    return s:stack[-1].package
endfunction

function! gotest#execution_history#lastFuntion()
    if s:stack == []
        return v:none
    endif
    return s:stack[-1].function
endfunction


" vim:set et:
