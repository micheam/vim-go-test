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

command! -nargs=? RunTest      call gotest#exec_test(<f-args>)
command!          RunTestFunc  call gotest#exec_test_func()
command!          EchoPackage  :echom gotest#detect_package()
command!          EchoTestFunc :echom gotest#detect_func()

nnoremap <silent> <Plug>(go_test_run_test)       :<C-u>RunTest<CR>
nnoremap <silent> <Plug>(go_test_run_test_func)  :<C-u>RunTestFunc<CR>

if exists('g:go_test_enable_default_key_mappings') 
            \ && g:go_test_enable_default_key_mappings

    silent! nmap <buffer> <Leader>tt <Plug>(go_test_run_test)
    silent! nmap <buffer> <Leader>tf <Plug>(go_test_run_test_func)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
