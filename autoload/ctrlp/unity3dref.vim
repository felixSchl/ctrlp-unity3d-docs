if get(g:, 'loaded_ctrlp_unity3dref', 0)
    finish
endif
let g:loaded_ctrlp_unity3dref = 1

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line
call add(g:ctrlp_ext_vars, {
  \ 'init':   'ctrlp#unity3dref#init()',
  \ 'accept': 'ctrlp#unity3dref#accept',
  \ 'lname':  'unity3d reference',
  \ 'sname':  'u3d ref',
  \ 'type':   'path',
  \ 'exit':   'ctrlp#exit()',
  \ 'nolim':  1,
  \ 'sort':   0
  \ })

let s:type_list = []

python << EOP
import vim
# obtain the type list
path_to_script = vim.eval('expand("<sfile>")')
path_to_types = path_to_script.replace('unity3dref.vim', 'type-index.txt')
with open(path_to_types) as f:
    types = [l.strip() for l in f.readlines()]

for t in types:
    vim.eval('add(s:type_list, "%s")' % t)
EOP

function! s:syntax()
    if ctrlp#nosy() | retu | en

    cal ctrlp#hicheck("CtrlPUnity3DUrl", "Comment")
    cal ctrlp#hicheck("CtrlPUnity3DType", "String")
    cal ctrlp#hicheck("CtrlPUnity3DMethod", "Keyword")

    sy match CtrlPUnity3DUrl '\[[^\]]*\]'
    sy match CtrlPUnity3DType '^[^\t\.]*'
    sy match CtrlPUnity3DMethod '\..*\t'
endfunction

function! ctrlp#unity3dref#init()
    call s:syntax()
    return s:type_list
endfunction

func! ctrlp#unity3dref#accept(mode, str)
    let url = matchstr(a:str, '\[\zs[^\]]\+\ze\]')
    let base_url = "https://docs.unity3d.com/Documentation/ScriptReference/"
    let url = base_url . url
    execute ":OpenBrowser " . url
    call ctrlp#exit()
    echo url
endfunc

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#unity3dref#id()
  return s:id
endfunction
