" buffer
" Version: 0.0.1
" Author: 
" License: 

echom "Autoloading..."
const s:buffer_name = "GO_TEST_RESULT"

fun! gotest#buffer#get_bufnr() abort
    let bufnr = bufadd(s:buffer_name)
    call bufload(bufnr)
    call setbufvar(bufnr, '&buftype', 'nofile')
    call setbufvar(bufnr, '&filetype', 'gotest')
    return bufnr
endfun

fun! gotest#buffer#is_open(bufnr)
    return a:bufnr->win_findbuf()->len() == 0
                \ ? v:false 
                \ : v:true
endfun

fun! gotest#buffer#execute(bufnr, cmd) abort
    let winids = win_findbuf(a:bufnr)
    if winids->len() == 0 
        return
    endif
    call map(winids, {_, wid -> win_execute(wid, a:cmd)})
    return
endfun

fun! gotest#buffer#clear(bufnr) abort
    call gotest#buffer#execute(a:bufnr, '1,$d')
endfun

fun! gotest#buffer#append_msg(bufnr, msglist = []) abort
    let msg = join(a:msglist)
    call appendbufline(a:bufnr, '$', msg)    
    call gotest#result_buf_execute('normal G')
endfun                                          

" vim:set et:
