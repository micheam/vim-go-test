" go
" Version: 0.0.1
" Author: 
" License: 

const s:go_test_success = 0
const s:go_test_fail = 1
const s:go_test_build_fail = 2

const s:subcommands = ["coverage"]

fun! go#detect_package() abort
    if &ft != 'go'
        throw "support only ft='go'"
    endif
    let dir = expand('%:p:h')
    let cmd = "go list " . dir
    let out = systemlist(cmd)     
    if v:shell_error != 0
        throw "Can't detect package: ".join(out, ":")
    endif
    return out[0]
endfun

fun! go#exec_test(target_func = v:null) abort
    let pkg = go#detect_package()
    let cmd = "go test ".pkg
    if a:target_func != v:null
        let cmd = cmd." -run=".a:target_func
    endif
    let out = systemlist(cmd)
    let test_result = v:shell_error
    if test_result == s:go_test_build_fail
        echom "BUILD FAIL: ".pkg
        return
    elseif test_result == s:go_test_fail
        echom "FAIL: ".pkg
        call setqflist(out, 'r', {'id' : s:qfid})
        copen
        return
    else 
        call setqflist([], 'r', {'id' : s:qfid})
        echom "OK: ".pkg
        return
    endif
endfun

fun! go#exec_test_coverage() abort
    let pkg = go#detect_package()
    let cmd = "go test ".pkg." -cover"
    let out = systemlist(cmd)
    let test_result = v:shell_error
    if test_result == s:go_test_build_fail
        echom "BUILD FAIL: ".pkg
        return
    elseif test_result == s:go_test_fail
        echom "FAIL: ".pkg
        return
    else 
        echom out[0]->substitute('\t', ' ',  'g')
        return
    endif
endfun

" vim:set et:
