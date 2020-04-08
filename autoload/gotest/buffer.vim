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

fun! gotest#buffer#execute(cmd) abort
    let winids = gotest#buffer#get_bufnr()->win_findbuf()
    if winids->len() == 0 
        return
    endif
    call map(winids, {_, wid -> win_execute(wid, a:cmd)})
    return
endfun

fun! gotest#buffer#clear() abort
    let bufnr = gotest#buffer#get_bufnr()
    call gotest#buffer#execute('1,$d')
endfun

fun! gotest#buffer#append_msg(msglist = []) abort
    let msg = a:msglist->join()
    let bufnr = gotest#buffer#get_bufnr()
    call appendbufline(bufnr, '$', msg)    
    call gotest#result_buf_execute('normal G')
endfun                                          

" vim:set et:
