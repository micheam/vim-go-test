" go
" Version: 0.0.1
" Author: 
" License: 

if exists('g:loaded_go_test')
  finish
endif

let g:loaded_go_test = 1
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -complete=buffer RunTest call gotest#exec_test(<f-args>)
command! RunTestCoverage call gotest#exec_test_coverage()
command! ShowPackage :echom gotest#detect_package()

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
