" go
" Version: 0.0.1
" Author: micheam <https://github.com/micheam>
" License: MIT

const s:go_test_success = 0
const s:go_test_fail = 1
const s:go_test_build_fail = 2

const s:qfconf = {
            \ 'title': 'GO TEST RESULT', 
            \ }
lockvar s:qfconf

let s:go_test_verbose = v:false
fun! gotest#set_vervose(v = v:false) abort 
    let s:go_test_verbose = a:v
endfu
fun! gotest#toggle_vervose() abort 
    let s:go_test_verbose = !s:go_test_verbose
endfu

fun! gotest#detect_package() abort
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

"fun! gotest#detect_func() abort
"    if &ft != 'go'
"        throw "support only ft='go'"
"    endif
"endfun

fun! gotest#exec_test(target_func = v:null) abort
    let pkg = gotest#detect_package()
    let cmd = "go test ".pkg
    if a:target_func != v:null
        let cmd = cmd." -run=".a:target_func
    endif
    if s:go_test_verbose == v:true
        let cmd = cmd." -v"
    endif
    let out = systemlist(cmd)
    let test_result = v:shell_error
    if test_result == s:go_test_build_fail
        echom "BUILD FAIL: ".pkg
        return
    elseif test_result == s:go_test_fail
        echom "FAIL: ".pkg
        call setqflist([], ' ', {'title': s:qfconf.title, 'lines': out})
        return
    else 
        call setqflist([], 'r', {'title': s:qfconf.title, 'lines': ["TEST OK"]})
        echom "OK: ".pkg
        return
    endif
endfun

" vim:set et:
