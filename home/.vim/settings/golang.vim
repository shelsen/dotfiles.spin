" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup golang_bindings
  au!
  au FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
  au FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go set listchars=tab:\ \ ,trail:·
augroup END

" let g:go_auto_type_info = 1
" set updatetime=200

let s:go_major_version = ""

if empty(s:go_major_version)
  let tokens = matchlist(go#util#Exec(['go', 'version']), '\d\+.\(\d\+\)\(\.\d\+\)\? ')
  if len(tokens) > 0
    let s:go_major_version = str2nr(tokens[1])
  else
    let s:go_major_version = ""
  endif
endif

if !empty(s:go_major_version) && s:go_major_version < "11"
  let g:go_def_mode = "godef"
endif

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

let g:go_fmt_command = "goimports"
