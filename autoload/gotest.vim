" go
" Version: 0.0.1
" Author: micheam <https://github.com/micheam>
" License: MIT

let s:Vital = vital#gotest#new()
let s:String = s:Vital.import("Data.String")
let s:Promise = s:Vital.import('Async.Promise')

"function! s:read(chan, part) abort
"    let out = []
"    while ch_status(a:chan, {'part' : a:part}) =~# 'open\|buffered'
"        call add(out, ch_read(a:chan, {'part' : a:part}))
"    endwhile
"    return join(out, "\n")
"endfunction
"
"function! gotest#sh(...) abort
"    let cmd = join(a:000, ' ')
"    return s:Promise.new({resolve, reject -> job_start(cmd, {
"                \   'drop' : 'never',
"                \   'close_cb' : {ch -> 'do nothing'},
"                \   'exit_cb' : {ch, code ->
"                \     code ? reject(s:read(ch, 'err')) : resolve(s:read(ch, 'out'))
"                \   },
"                \ })})
"endfunction

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

fun! gotest#_qflist_map(lines = [], qfm = v:null) abort 
    let m = {'title': s:qfconf.title, 'lines': a:lines}
    if a:qfm != v:null
        let m['qfm'] = a:qfm
    endif
    return m
endfunc 

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

fun! gotest#detect_func() abort
    if &ft != 'go'
        throw "support only ft='go'"
    endif

    let lnum = line(".")
    let found = ""

    while lnum > 0
        let scanned = s:String.scan(getline(lnum), gotest#_get_func_pattern())
        if len(scanned) > 0
            let found = scanned[0]
            break
        endif
        let lnum = lnum - 1 
    endwhile

    if found == ""
        throw "test func not-found"
    endif
    return found
endfun

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
        let what = gotest#_qflist_map(out, gotest#_get_qfm())
        call setqflist([], ' ', what)
        if gotest#_need_auto_open()
            :copen
        endif
        return
    else 
        echom "OK: ".pkg
        let what = gotest#_qflist_map(["TEST OK"])
        call setqflist([], ' ', what)
        return
    endif
endfun

fun! gotest#exec_test_func() abort
    let fun_name = gotest#detect_func()
    call gotest#exec_test(fun_name)
endfun

" vim:set et:
