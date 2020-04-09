" go
" Version: 0.0.1
" Author: micheam <https://github.com/micheam>
" License: MIT

const s:go_test_success = 0
const s:go_test_fail = 1
const s:go_test_build_fail = 2

func! gotest#_get_func_pattern()
    if exists('g:go_test_func_pattern')
        return g:go_test_func_pattern
    endif
    return "^func\\s\\zsTest\\w\\+\\ze"
endfunc

func! gotest#_get_qfm()
    if exists('g:go_test_qfm')
        return g:go_test_qfm
    endif
    return v:null
endfunc

func! gotest#_need_auto_open()
    if exists('g:go_test_open_qf_on_failure')
        return g:go_test_open_qf_on_failure
    endif
    return v:false
endfunc

fun! gotest#vervose() abort 
    if exists('g:go_test_vervose')
        return g:go_test_vervose
    endif
    return v:false
endfu

const s:qfconf = {
            \ 'title': 'GO TEST RESULT', 
            \ }
lockvar s:qfconf

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

fun! gotest#detect_func() abort
    if &ft != 'go'
        throw "support only ft='go'"
    endif
    let lnum = line(".")
    let found = ""
    let pat = gotest#_get_func_pattern()
    while lnum > 0
        let matched = []
        call substitute(
                    \ getline(lnum), pat, 
                    \ '\=add(matched, submatch(0))', '')
        if len(matched) > 0
            let found = matched[0]
            break
        endif
        let lnum = lnum - 1 
    endwhile
    if found == ""
        throw "test func not-found"
    endif
    return found
endfun

fun! gotest#handle_exit(job, exit_status) abort
    if !a:exit_status
        echo "GO_TEST: Success"
    else
        echohl WarningMsg |
                    \ echom "GO_TEST: Failure" |
                    \ echohl None
    endif
endfun

fun! gotest#exec_test(target_func = v:null) abort
    let pkg = gotest#detect_package()
    let cmd = ["go", "test", pkg, "-count=1"]
    if a:target_func != v:null
        let cmd = cmd->add("-run=".a:target_func)
    endif
    if gotest#vervose() == v:true
        let cmd = cmd->add("-v")
    endif

    call gotest#buffer#clear()
    call gotest#buffer#append_msg(
                \ a:target_func != v:null ?
                \ [pkg, a:target_func] : [pkg]
                \)
    let job = job_start(cmd, {
                \ 'callback': {_, msg -> 
                \     gotest#buffer#append_msg([">>", msg])},
                \ 
                \ 'exit_cb': {job, exit_status -> 
                \     gotest#handle_exit(job, exit_status)},
                \ })
endfun

fun! gotest#exec_test_func() abort
    let fun_name = gotest#detect_func()
    call gotest#exec_test(fun_name)
endfun

" vim:set et:
