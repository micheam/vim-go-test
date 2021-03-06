" go
" Version: 0.0.1
" Author: 
" License: 

if exists('g:loaded_go_test') && !exists('g:force_reload_go_test') 
    finish
endif

let g:loaded_go_test = 1
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? RunTest         call gotest#exec_test(<f-args>)
command!          ReRunLast       call gotest#exec_last_test()
command!          RunTestFunc     call gotest#exec_test_func()
command!          EchoPackage     :echom gotest#detect_package()
command!          EchoTestFunc    :echom gotest#detect_func()

command!          TestResultClear  call gotest#clear_result_buf()
command!          TestResultOpen   call gotest#open_result_buffer()
command!          TestResultClose  call gotest#close_result_buffer()
command!          TestResultToggle call gotest#toggle_result_buffer()

nnoremap <silent> <Plug>(go_test_run_test)        :<C-u>RunTest<CR>
nnoremap <silent> <Plug>(go_test_rerun_last_test) :<C-u>ReRunLast<CR>
nnoremap <silent> <Plug>(go_test_run_test_func)   :<C-u>RunTestFunc<CR>
nnoremap <silent> <Plug>(go_test_clear_result)    :<C-u>TestResultClear<CR>
nnoremap <silent> <Plug>(go_test_toggle_result)   :<C-u>TestResultToggle<CR>

if exists('g:go_test_enable_default_key_mappings') 
    silent! nmap <buffer> <Leader>tt <Plug>(go_test_run_test_func)
    silent! nmap <buffer> <Leader>tl <Plug>(go_test_rerun_last_test)
    silent! nmap <buffer> <Leader>tp <Plug>(go_test_run_test)
    silent! nmap <buffer> <Leader>tc <Plug>(go_test_clear_result)
    silent! nmap <buffer> <Leader>tr <Plug>(go_test_toggle_result)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
