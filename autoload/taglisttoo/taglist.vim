" Author:  Eric Van Dewoestine
"
" License: {{{
"   Copyright (c) 2005 - 2013, Eric Van Dewoestine
"   All rights reserved.
"
"   Redistribution and use of this software in source and binary forms, with
"   or without modification, are permitted provided that the following
"   conditions are met:
"
"   * Redistributions of source code must retain the above
"     copyright notice, this list of conditions and the
"     following disclaimer.
"
"   * Redistributions in binary form must reproduce the above
"     copyright notice, this list of conditions and the
"     following disclaimer in the documentation and/or other
"     materials provided with the distribution.
"
"   * Neither the name of Eric Van Dewoestine nor the names of its
"     contributors may be used to endorse or promote products derived from
"     this software without specific prior written permission of
"     Eric Van Dewoestine.
"
"   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
"   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
"   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
"   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
"   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
"   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
"   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
"   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
"   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
"   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
"   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
" }}}

" Global Variables {{{
let g:TagListToo = 1
" }}}

" Script Variables {{{
  let s:python_path = expand("<sfile>:h:h")

  " used to prefer one window over another if a buffer is open in more than
  " one window.
  let s:taglisttoo_prevwinnr = 0

  let s:taglisttoo_title = g:TagList_title
" }}}

" Language Settings {{{
let s:tlist_ant_settings = {
    \ 'lang': 'ant',
    \ 'parse': 'taglisttoo#lang#ant#Parse',
    \ 'tags': {
      \ 'p': 'project',
      \ 'i': 'import',
      \ 'r': 'property',
      \ 't': 'target'
    \ }
  \ }

" assembly language
let s:tlist_asm_settings = {
    \ 'lang': 'asm', 'tags': {
      \ 'd': 'define',
      \ 'l': 'label',
      \ 'm': 'macro',
      \ 't': 'type'
    \ }
  \ }

" aspperl language
let s:tlist_aspperl_settings = {
    \ 'lang': 'asp', 'tags': {
      \ 'f': 'function',
      \ 's': 'sub',
      \ 'v': 'variable'
    \ }
  \ }

" aspvbs language
let s:tlist_aspvbs_settings = {
    \ 'lang': 'asp', 'tags': {
      \ 'f': 'function',
      \ 's': 'sub',
      \ 'v': 'variable'
    \ }
  \ }

" awk language
let s:tlist_awk_settings = {'lang': 'awk', 'tags': {'f': 'function'}}

" beta language
let s:tlist_beta_settings = {
    \ 'lang': 'beta', 'tags': {
      \ 'f': 'fragment',
      \ 's': 'slot',
      \ 'v': 'pattern'
    \ }
  \ }

" c language
let s:tlist_c_settings = {
    \ 'lang': 'c', 'tags': {
      \ 'd': 'macro',
      \ 'g': 'enum',
      \ 's': 'struct',
      \ 'u': 'union',
      \ 't': 'typedef',
      \ 'v': 'variable',
      \ 'f': 'function'
    \ }
  \ }

" c++ language
let s:tlist_cpp_settings = {
    \ 'lang': 'c++',
    \ 'separator': '::',
    \ 'parse': 'taglisttoo#lang#cpp#Parse',
    \ 'tags': {
      \ 'n': 'namespace',
      \ 'v': 'variable',
      \ 'd': 'macro',
      \ 't': 'typedef',
      \ 'c': 'class',
      \ 'g': 'enum',
      \ 's': 'struct',
      \ 'u': 'union',
      \ 'f': 'function',
      \ 'p': 'prototypes',
    \ }
  \ }

" c# language
let s:tlist_cs_settings = {
    \ 'lang': 'c#', 'tags': {
      \ 'd': 'macro',
      \ 't': 'typedef',
      \ 'n': 'namespace',
      \ 'c': 'class',
      \ 'E': 'event',
      \ 'g': 'enum',
      \ 's': 'struct',
      \ 'i': 'interface',
      \ 'p': 'properties',
      \ 'm': 'method'
    \ }
  \ }

" clojure
let s:tlist_clojure_settings = {'lang': 'lisp', 'tags': {'f': 'function'}}

" cobol language
let s:tlist_cobol_settings = {
    \ 'lang': 'cobol', 'tags': {
      \ 'd': 'data',
      \ 'f': 'file',
      \ 'g': 'group',
      \ 'p': 'paragraph',
      \ 'P': 'program',
      \ 's': 'section'
    \ }
  \ }

let s:tlist_dtd_settings = {
    \ 'lang': 'dtd',
    \ 'parse': 'taglisttoo#lang#dtd#Parse',
    \ 'tags': {'e': 'element'}
  \ }

" eiffel language
let s:tlist_eiffel_settings = {
    \ 'lang': 'eiffel', 'tags': {
      \ 'c': 'class',
      \ 'f': 'feature'
    \ }
  \ }

" erlang language
let s:tlist_erlang_settings = {
    \ 'lang': 'erlang', 'tags': {
      \ 'd': 'macro',
      \ 'r': 'record',
      \ 'm': 'module',
      \ 'f': 'function'
    \ }
  \ }

" expect (same as tcl) language
let s:tlist_expect_settings = {
    \ 'lang': 'tcl', 'tags': {
      \ 'c': 'class',
      \ 'f': 'method',
      \ 'p': 'procedure'
    \ }
  \ }

" fortran language
let s:tlist_fortran_settings = {
    \ 'lang': 'fortran', 'tags': {
      \ 'p': 'program',
      \ 'b': 'block data',
      \ 'c': 'common',
      \ 'e': 'entry',
      \ 'i': 'interface',
      \ 'k': 'type',
      \ 'l': 'label',
      \ 'm': 'module',
      \ 'n': 'namelist',
      \ 't': 'derived',
      \ 'v': 'variable',
      \ 'f': 'function',
      \ 's': 'subroutine'
    \ }
  \ }

let s:tlist_html_settings = {
    \ 'lang': 'html',
    \ 'parse': 'taglisttoo#lang#html#Parse',
    \ 'tags': {'a': 'anchor', 'i': 'id', 'f': 'function'}
  \ }

let s:tlist_htmldjango_settings = {
    \ 'lang': 'htmldjango',
    \ 'parse': 'taglisttoo#lang#htmldjango#Parse',
    \ 'tags': {'a': 'anchor', 'i': 'id', 'f': 'function', 'b': 'block'}
  \ }

let s:tlist_htmljinja_settings = {
    \ 'lang': 'htmljinja',
    \ 'parse': 'taglisttoo#lang#htmljinja#Parse',
    \ 'tags': {
      \ 'a': 'anchor',
      \ 'i': 'id',
      \ 'f': 'function',
      \ 'm': 'macro',
      \ 'b': 'block'
    \ }
  \ }

" java language
let s:tlist_java_settings = {
    \ 'lang': 'java',
    \ 'tags': {
      \ 'p': 'package',
      \ 'c': 'class',
      \ 'i': 'interface',
      \ 'f': 'field',
      \ 'm': 'method'
    \ }
  \ }

let s:tlist_javascript_settings = {
    \ 'lang': 'javascript',
    \ 'parse': 'taglisttoo#lang#javascript#Parse',
    \ 'tags': {
      \ 'o': 'object',
      \ 'f': 'function',
    \ }
  \ }

let s:tlist_jproperties_settings = {
    \ 'lang': 'jproperties',
    \ 'parse': 'taglisttoo#lang#jproperties#Parse',
    \ 'tags': {'p': 'property'}
  \ }

" lisp language
let s:tlist_lisp_settings = {'lang': 'lisp', 'tags': {'f': 'function'}}

let s:tlist_log4j_settings = {
    \ 'lang': 'log4j',
    \ 'parse': 'taglisttoo#lang#log4j#Parse',
    \ 'tags': {
      \ 'a': 'appender',
      \ 'c': 'category',
      \ 'l': 'logger',
      \ 'r': 'root',
    \ }
  \ }

" lua language
let s:tlist_lua_settings = {'lang': 'lua', 'tags': {'f': 'function'}}

" makefiles
let s:tlist_make_settings = {'lang': 'make', 'tags': {'m': 'macro'}}

" pascal language
let s:tlist_pascal_settings = {
    \ 'lang': 'pascal', 'tags': {
      \ 'f': 'function',
      \ 'p': 'procedure'
    \ }
  \ }

" perl language
let s:tlist_perl_settings = {
    \ 'lang': 'perl',
    \ 'parse': 'taglisttoo#lang#perl#Parse',
    \ 'tags': {
      \ 'c': 'constant',
      \ 'l': 'label',
      \ 'p': 'package',
      \ 's': 'subroutine'
    \ }
  \ }

" php language
let s:tlist_php_settings = {
    \ 'lang': 'php',
    \ 'parse': 'taglisttoo#lang#php#Parse',
    \ 'tags': {
      \ 'c': 'class',
      \ 'd': 'constant',
      \ 'v': 'variable',
      \ 'f': 'function',
      \ 'i': 'interface'
    \ }
  \ }

" python language
let s:tlist_python_settings = {
    \ 'lang': 'python',
    \ 'tags': {
      \ 'c': 'class',
      \ 'm': 'function',
      \ 'f': 'function'
    \ }
  \ }

" rexx language
let s:tlist_rexx_settings = {'lang': 'rexx', 'tags': {'s': 'subroutine'}}

let s:tlist_rst_settings = {
    \ 'lang': 'rst',
    \ 'parse': 'taglisttoo#lang#rst#Parse',
    \ 'tags': {'s': 'section', 'a': 'anchor'}
  \ }

" ruby language
let s:tlist_ruby_settings = {
    \ 'lang': 'ruby', 'tags': {
      \ 'c': 'class',
      \ 'm': 'class',
      \ 'f': 'function',
      \ 'F': 'singleton method'
    \ }
  \ }

" scala language
let s:tlist_scala_settings = {
    \ 'lang': 'scala',
    \ 'parse': 'taglisttoo#lang#scala#Parse',
    \ 'tags': {
      \ 'p': 'package',
      \ 'c': 'class',
      \ 'o': 'object',
      \ 't': 'trait',
      \ 'T': 'type',
      \ 'm': 'method',
    \ }
  \ }
  " parsed for correct detection of parent tags, but not displayed to reduce
  " clutter
  "    \ 'C': 'constant',
  "    \ 'l': 'local variable',

" scheme language
let s:tlist_scheme_settings = {
    \ 'lang': 'scheme', 'tags': {
      \ 's': 'set',
      \ 'f': 'function'
    \ }
  \ }

" shell language
let s:tlist_sh_settings = {'lang': 'sh', 'tags': {'f': 'function'}}

" C shell language
let s:tlist_csh_settings = {'lang': 'sh', 'tags': {'f': 'function'}}

" Z shell language
let s:tlist_zsh_settings = {'lang': 'sh', 'tags': {'f': 'function'}}

" slang language
let s:tlist_slang_settings = {
    \ 'lang': 'slang', 'tags': {
      \ 'n': 'namespace',
      \ 'f': 'function'
    \ }
  \ }

" sml language
let s:tlist_sml_settings = {
    \ 'lang': 'sml', 'tags': {
      \ 'e': 'exception',
      \ 'c': 'functor',
      \ 's': 'signature',
      \ 'r': 'structure',
      \ 't': 'type',
      \ 'v': 'value',
      \ 'f': 'function'
    \ }
  \ }

let s:tlist_sql_settings = {
    \ 'lang': 'sql',
    \ 'parse': 'taglisttoo#lang#sql#Parse',
    \ 'tags': {
      \ 'g': 'group / role',
      \ 'r': 'role',
      \ 'u': 'user',
      \ 'm': 'user',
      \ 'p': 'tablespace',
      \ 'z': 'tablespace',
      \ 's': 'schema',
      \ 't': 'table',
      \ 'v': 'view',
      \ 'q': 'sequence',
      \ 'x': 'trigger',
      \ 'f': 'function',
      \ 'c': 'procedure'
    \ }
  \ }

" tcl language
let s:tlist_tcl_settings = {
    \ 'lang': 'tcl', 'tags': {
      \ 'c': 'class',
      \ 'f': 'method',
      \ 'm': 'method',
      \ 'p': 'procedure'
    \ }
  \ }

" vera language
let s:tlist_vera_settings = {
    \ 'lang': 'vera', 'tags': {
      \ 'c': 'class',
      \ 'd': 'macro',
      \ 'e': 'enumerator',
      \ 'f': 'function',
      \ 'g': 'enum',
      \ 'm': 'member',
      \ 'p': 'program',
      \ 'P': 'prototype',
      \ 't': 'task',
      \ 'T': 'typedef',
      \ 'v': 'variable',
      \ 'x': 'externvar'
    \ }
  \ }

"verilog language
let s:tlist_verilog_settings = {
    \ 'lang': 'verilog', 'tags': {
      \ 'm': 'module',
      \ 'c': 'constant',
      \ 'P': 'parameter',
      \ 'e': 'event',
      \ 'r': 'register',
      \ 't': 'task',
      \ 'w': 'write',
      \ 'p': 'port',
      \ 'v': 'variable',
      \ 'f': 'function'
    \ }
  \ }

" vim language
let s:tlist_vim_settings = {
    \ 'lang': 'vim',
    \ 'parse': 'taglisttoo#lang#vim#Parse',
    \ 'tags': {
      \ 'a': 'autocmds',
      \ 'v': 'variable',
      \ 'f': 'function'
    \ }
  \ }

let s:tlist_xsd_settings = {
    \ 'lang': 'xsd',
    \ 'parse': 'taglisttoo#lang#xsd#Parse',
    \ 'tags': {'e': 'elements', 't': 'types'}
  \ }

" yacc language
let s:tlist_yacc_settings = {'lang': 'yacc', 'tags': {'l': 'label'}}
" }}}

function! taglisttoo#taglist#AutoOpen() " {{{
  let winnum = s:GetTagListWinnr()
  if winnum != -1
    return
  endif

  let open_window = 0

  let i = 1
  let buf_num = winbufnr(i)
  while buf_num != -1
    let filename = fnamemodify(bufname(buf_num), ':p')
    if !getbufvar(buf_num, '&diff') &&
     \ s:FileSupported(filename, getbufvar(buf_num, '&filetype'))
      let open_window = 1
      break
    endif
    let i = i + 1
    let buf_num = winbufnr(i)
  endwhile

  if open_window
    call taglisttoo#taglist#Taglist()
    let t:Tlist_Auto_Opened = 1
  endif
endfunction " }}}

function! taglisttoo#taglist#Taglist(...) " {{{
  " Optional arg:
  "   options:
  "     action:
  "       - not supplied (or -1): toggle
  "       - 1: open
  "       - 0: close
  "     pick:
  "       - 1: opening the taglist temporarily to simply pick a tag then
  "            close.

  if !exists('g:Tlist_Ctags_Cmd')
    call taglisttoo#util#EchoError('Unable to find a version of ctags installed.')
    return
  endif

  call s:Init()

  let options = len(a:000) ? a:000[0] : {}
  let action = get(options, 'action', -1)

  if action == -1 || action == 0
    let winnum = s:GetTagListWinnr()
    if winnum != -1
      let prevbuf = bufnr('%')
      " handle closing from the taglist
      if bufwinnr(prevbuf) == winnum
        wincmd p
        let prevbuf = bufnr('%')
      else
        let s:taglisttoo_prevwinnr = winnr()
      endif

      " if closing the taglist window will affect the numbering of our stored
      " previous window number, then adjust it accordingly
      if s:taglisttoo_prevwinnr &&
       \ winbufnr(s:taglisttoo_prevwinnr) == prevbuf &&
       \ s:taglisttoo_prevwinnr > winnum
        let s:taglisttoo_prevwinnr -= 1
      endif

      noautocmd exe winnum . 'wincmd w'
      noautocmd close
      call s:Cleanup()
      call s:JumpToFileWindow(prevbuf)

      return
    endif
  endif

  if action == -1 || action == 1
    call s:ProcessTags({'force': 1, 'pick': get(options, 'pick', 0)})
  endif
endfunction " }}}

function! taglisttoo#taglist#Restore() " {{{
  " Restore the taglist, typically after loading from a session file.

  if exists('t:taglistoo_restoring')
    return
  endif
  let t:taglistoo_restoring = 1

  " prevent auto open from firing after session is loaded.
  augroup taglisttoo_autoopen
    autocmd!
  augroup END

  let winnum = s:GetTagListWinnr()
  if winnum != -1
    TlistToo
    TlistToo
    unlet t:taglistoo_restoring
  endif
endfunction " }}}

function! s:Init() " {{{
python << PYTHONEOF
import sys, vim
path = vim.eval('s:python_path')
if path not in sys.path:
  sys.path.append(path)
  import taglisttoo
PYTHONEOF
endfunction " }}}

function! s:StartAutocmds() " {{{
  augroup taglisttoo
    autocmd! * <buffer>
    autocmd! * *
    autocmd BufUnload <buffer> call s:Cleanup()
    autocmd CursorHold * call s:ShowCurrentTag()
  augroup END

  augroup taglisttoo_file
    autocmd! * <buffer>
    autocmd! * *
    autocmd CursorHold,CursorMoved <buffer> call s:EchoTag()
    autocmd BufEnter <buffer> nested call s:CloseIfLastWindow()
    autocmd BufEnter *
      \ if s:GetTagListWinnr() != -1 |
      \   call s:ProcessTags() |
      \ endif
    autocmd BufWritePost *
      \ if s:GetTagListWinnr() != -1 |
      \   call s:ProcessTags({'force': 1}) |
      \ endif
    " bit of a hack to re-process tags if the filetype changes after the tags
    " have been processed.
    autocmd FileType *
      \ if exists('b:ft') |
      \   if b:ft != &ft |
      \     if s:GetTagListWinnr() != -1 |
      \       call s:ProcessTags({'force': 1}) |
      \     endif |
      \     let b:ft = &ft |
      \   endif |
      \ else |
      \   let b:ft = &ft |
      \ endif
    autocmd WinLeave *
      \ if s:GetTagListWinnr() != -1 && &buftype == '' |
      \   let s:taglisttoo_prevwinnr = winnr() |
      \ endif
  augroup END
endfunction " }}}

function! s:Cleanup() " {{{
  let bufnr = s:GetTagListBufnr()
  if bufnr != -1
    augroup taglisttoo_file
      exec 'autocmd! * <buffer=' . bufnr . '>'
    augroup END

    augroup taglisttoo
      exec 'autocmd! * <buffer=' . bufnr . '>'
    augroup END
  endif

  " TODO: clear all b:taglisttoo_folds variables?
endfunction " }}}

function! s:ProcessTags(...) " {{{
  " Optional arg:
  "   options:
  "     force: force the tags to be process (newly opened files + file writes)
  "     pick: processing tags as part of command to just pick the tag then
  "       close the tag list.

  " on insert completion prevent vim's jumping back and forth from the
  " completion preview window from triggering a re-processing of tags
  if pumvisible()
    return
  endif

  if winnr() == s:GetTagListWinnr()
    return
  endif

  let options = len(a:000) ? a:000[0] : {}

  " if tag processes is not forced and we are entering a buffer whose taglist
  " list is already loaded, then don't do anything.
  if !get(options, 'force', 0)
    let bufnr = s:GetTagListBufnr()
    let filebuf = getbufvar(bufnr, 'taglisttoo_file_bufnr')
    if filebuf == bufnr('%')
      return
    endif
  endif

  let filename = expand('%:p')
  if filename == '' || &buftype != ''
    return
  endif

  let filebuf = bufnr('%')

  if s:FileSupported(expand('%:p'), &ft)
    if exists('g:tlist_{&ft}_settings')
      if type(g:tlist_{&ft}_settings) == 1
        let values = split(g:tlist_{&ft}_settings, ';')
        let tag_settings = {}
        for value in values[1:]
          let [key, value] = split(value, ':')
          let tag_settings[key] = value
        endfor
        let settings = {
            \ 'lang': values[0],
            \ 'tags': tag_settings,
          \ }
      else
        let settings = g:tlist_{&ft}_settings
      endif
    else
      let settings = s:tlist_{&ft}_settings
    endif

    let file = substitute(expand('%:p'), '\', '/', 'g')

    " support generated file contents (like viewing a .class file via jad)
    let tempfile = ''
    if !filereadable(file) || &buftype == 'nofile'
      let tempfile = g:EclimTempDir . '/' . fnamemodify(file, ':t')
      if tolower(file) != tolower(tempfile)
        let tempfile = escape(tempfile, ' ')
        exec 'write! ' . tempfile
        let file = tempfile
      endif
    endif

    try
      if has_key(settings, 'parse')
        let tags = s:Function(settings.parse)(file, settings)
      else
        let tags = taglisttoo#util#ParseCtags(file, settings)
      endif
    catch /E700/
      call taglisttoo#util#EchoError('Unknown function: ' . settings.parse)
      return
    finally
      if tempfile != ''
        call delete(tempfile)
      endif
    endtry

    if type(tags) != 3
      return
    endif

    let temp = get(options, 'pick', 0)
    call s:Window(settings, tags, temp)
    call s:JumpToFileWindow(filebuf)
    call s:ShowCurrentTag()

    " after showing the current tag jump back to the tag list if we're
    " expecting the user to pick a tag and then close the window.
    if temp
      let twinnum = s:GetTagListWinnr()
      exec twinnum . 'winc w'
    endif
  else
    " if the file isn't supported, then don't open the taglist window if it
    " isn't open already.
    let winnum = s:GetTagListWinnr()
    if winnum != -1
      call s:Window({'tags': {}}, [], 0)
      winc p
    endif
  endif
endfunction " }}}

function! s:FormatDefault(settings, tags) " {{{
  let formatter = taglisttoo#util#Formatter(a:settings, a:tags)
  call formatter.filename()

  for key in keys(a:settings.tags)
    let values = filter(copy(a:tags),
      \ 'v:val.type == key && get(v:val, "parent", "") == ""')
    if len(values)
      call formatter.blank()
      call formatter.format(values, "")
    endif
  endfor

  return formatter
endfunction " }}}

function! s:FormatEmpty(types, tags) " {{{
  return taglisttoo#util#Formatter(a:types, a:tags)
endfunction " }}}

function! s:GetTagInfo() " {{{
  if line('.') > len(b:taglisttoo_content[0])
    return {}
  endif

  let index = b:taglisttoo_content[0][line('.') - 1]
  if index == -1 || (type(index) == 1 && index == 'label')
    return {}
  endif

  return b:taglisttoo_tags[index]
endfunction " }}}

function! s:EchoTag() " {{{
  if g:TaglistTooTagEcho
    let tag_info = s:GetTagInfo()
    if len(tag_info)
      echo 'tag: ' . tag_info.name
    else
      echo ''
    endif
  endif
endfunction " }}}

function! s:FoldLevel(lnum) " {{{
  if !exists('b:taglisttoo_content')
    return -1
  endif

  let index = b:taglisttoo_content[0][a:lnum - 1]
  if index == -1
    return 0
  endif

  let lnum = a:lnum
  let indent = indent(lnum)
  let level = (indent / &shiftwidth) + 1
  if lnum != line('$')
    if indent < indent(lnum + 1)
      return '>' . level
    elseif lnum != 1 && indent > indent(lnum + 1)
      return '<' . ((indent(lnum - 1) / &shiftwidth) + 1)
    endif
  endif
  return '='
endfunction " }}}

function! s:FoldClose() " {{{
  silent! foldclose
  let line = foldclosed('.')
  if line != -1
    let folds = s:GetFolds()
    let path = s:GetFoldPath(line)
    if len(path)
      call add(folds, path)
      call setbufvar(b:taglisttoo_file_bufnr, 'taglisttoo_folds', folds)
    endif
  endif
endfunction " }}}

function! s:FoldOpen() " {{{
  let line = foldclosed('.')
  if line != -1
    let folds = s:GetFolds()
    let path = s:GetFoldPath(line)
    let index = index(folds, path)
    if index != -1
      call remove(folds, index)
      call setbufvar(b:taglisttoo_file_bufnr, 'taglisttoo_folds', folds)
    endif
  endif
  silent! foldopen
endfunction " }}}

function! s:FoldOpenAll() " {{{
  call setbufvar(b:taglisttoo_file_bufnr, 'taglisttoo_folds', [])
  setlocal foldlevel=99
endfunction " }}}

function! s:FoldToggle() " {{{
  if foldclosed('.') != -1
    call s:FoldOpen()
  else
    call s:FoldClose()
  endif
endfunction " }}}

function! s:FoldPath(path) " {{{
  call cursor(1, 1)

  let fold = 1
  let index = 0
  while index < len(a:path)
    let fold = search('^\s*' . a:path[index] . '\s*$', 'cW')
    if !fold
      let folds = s:GetFolds()
      let index = index(folds, a:path)
      if index != -1
        call remove(folds, index)
        call setbufvar(b:taglisttoo_file_bufnr, 'taglisttoo_folds', folds)
      endif
      break
    endif

    " make sure we didn't hit a tag that looks like a label
    let line = getline('.')
    let syntax = synIDattr(synID(fold, len(line), 1), 'name')
    if syntax != 'TagListKeyword'
      call cursor(line('.') + 1, 1)
      continue
    endif

    let index += 1
  endwhile

  if fold
    foldclose
  endif
endfunction " }}}

function! s:GetFolds() " {{{
  let folds = getbufvar(b:taglisttoo_file_bufnr, 'taglisttoo_folds')
  if type(folds) != 3 " not a list
    unlet folds | let folds = []
  endif
  return folds
endfunction " }}}

function! s:GetFoldPath(lnum) " {{{
  let path = []

  let lnum = a:lnum
  let indent = indent(lnum)
  while lnum >= 1
    let line = getline(lnum)
    let syntax = synIDattr(synID(lnum, len(line), 1), 'name')
    if syntax == 'TagListKeyword' && (lnum == a:lnum || indent(lnum) < indent)
      call insert(path, substitute(line, '\(^\s*\|\s*$\)', '', 'g'))
    endif
    let indent = indent(lnum)
    if indent == 0
      break
    endif
    let lnum -= 1
  endwhile

  return path
endfunction " }}}

function! s:JumpToTag(close) " {{{
  let tag_info = s:GetTagInfo()
  if !len(tag_info) || tag_info.line == -1 || get(tag_info, 'pattern', '') == ''
    return
  endif

  call s:JumpToFileWindow(b:taglisttoo_file_bufnr)

  let lnum = tag_info.line
  let pattern = tag_info.pattern

  " account for any plugins which may remove trailing spaces from the file
  let pattern = escape(pattern, '.~*[]')
  let pattern = substitute(pattern, '\s\+\$$', '\\s*$', '')

  if getline(lnum) =~ pattern
    mark '
    call cursor(lnum, 1)
    call s:ShowCurrentTag()
  else
    let pos = getpos('.')

    call cursor(lnum, 1)

    let up = search(pattern, 'bcnW')
    let down = search(pattern, 'cnW')

    " pattern found below recorded line
    if !up && down
      let line = down

    " pattern found above recorded line
    elseif !down && up
      let line = up

    " pattern found above and below recorded line
    elseif up && down
      " use the closest match to the recorded line
      if (lnum - up) < (down - lnum)
        let line = up
      else
        let line = down
      endif

    " pattern not found.
    else
      let line = 0
    endif

    call setpos('.', pos)
    if line
      mark '
      call cursor(line, 1)
      call s:ShowCurrentTag()
    endif
  endif

  if a:close
    call taglisttoo#taglist#Taglist({'action': 0})
  endif
endfunction " }}}

function! s:JumpToFileWindow(bufnr) " {{{
  " handle case of buffer open in multiple windows.
  if s:taglisttoo_prevwinnr && winbufnr(s:taglisttoo_prevwinnr) == a:bufnr
    exec s:taglisttoo_prevwinnr . 'wincmd w'
  else
    exec bufwinnr(a:bufnr) . 'wincmd w'
  endif
endfunction " }}}

function! s:Window(settings, tags, temp) " {{{
  let file_bufnr = bufnr('%')
  let folds = exists('b:taglisttoo_folds') ? b:taglisttoo_folds : []

  let winnum = s:GetTagListWinnr()
  if winnum == -1
    let position = g:TaglistTooPosition == 'right' ? 'botright' : 'topleft'
    silent exec position . ' vertical ' . g:Tlist_WinWidth .
      \ ' split ' . escape(s:taglisttoo_title, ' ')

    let winnum = s:GetTagListWinnr()
    exe winnum . 'wincmd w'

    setlocal filetype=taglist
    setlocal buftype=nofile bufhidden=delete
    setlocal noswapfile nobuflisted
    setlocal expandtab shiftwidth=2 tabstop=2
    setlocal winfixwidth
    setlocal nowrap nonumber
    setlocal foldmethod=expr foldlevel=99

    syn match TagListFileName "^.*\%1l.*"
    hi link TagListFileName Identifier
    hi link TagListKeyword Statement
    hi TagListCurrentTag term=bold,underline cterm=bold,underline gui=bold,underline
    hi TagListVisibilityPublic    ctermfg=green   guifg=SeaGreen
    hi TagListVisibilityPrivate   ctermfg=red     guifg=Red
    hi TagListVisibilityProtected ctermfg=blue    guifg=Blue
    hi TagListVisibilityStatic    ctermfg=magenta guifg=Magenta
    if has('gui') && &background == 'dark'
      hi TagListVisibilityPublic    guifg=#8eb157
      hi TagListVisibilityPrivate   guifg=#cf6171
      hi TagListVisibilityProtected guifg=#6699cc
      hi TagListVisibilityStatic    guifg=#cf9ebe
    endif

    exec 'nnoremap <silent> <buffer> <cr> :call <SID>JumpToTag(' . a:temp . ')<cr>'

    " folding related mappings
    nnoremap <silent> <buffer> o  :call <SID>FoldToggle()<cr>
    nnoremap <silent> <buffer> za :call <SID>FoldToggle()<cr>
    nnoremap <silent> <buffer> zA :call <SID>FoldToggle()<cr>
    nnoremap <silent> <buffer> zc :call <SID>FoldClose()<cr>
    nnoremap <silent> <buffer> zC :call <SID>FoldClose()<cr>
    nnoremap <silent> <buffer> zo :call <SID>FoldOpen()<cr>
    nnoremap <silent> <buffer> zO :call <SID>FoldOpen()<cr>
    nnoremap <silent> <buffer> zn :call <SID>FoldOpenAll()<cr>
    nnoremap <silent> <buffer> zR :call <SID>FoldOpenAll()<cr>
    nnoremap <silent> <buffer> zx <Nop>
    nnoremap <silent> <buffer> zX <Nop>
    nnoremap <silent> <buffer> zm <Nop>
    nnoremap <silent> <buffer> zM <Nop>
    nnoremap <silent> <buffer> zN <Nop>
    nnoremap <silent> <buffer> zr <Nop>
    nnoremap <silent> <buffer> zi <Nop>

    call s:StartAutocmds()

    noautocmd wincmd p
    " handle hopefully rare case where the previous window is not the file's
    " window.
    if file_bufnr != bufnr('%')
      let file_winnr = bufwinnr(file_bufnr)
      if file_winnr != -1
        exec 'noautocmd ' . file_winnr . 'wincmd w'
      else
        return
      endif
    endif
  endif

  if has_key(a:settings, 'format')
    let formatter = a:settings.format
  elseif len(a:tags)
    let formatter = 's:FormatDefault'
  else
    let formatter = 's:FormatEmpty'
  endif

  try
    let format = s:Function(formatter)(a:settings, a:tags)
  catch /E700/
    call taglisttoo#util#EchoError('Unknown function: ' . formatter)
    return
  endtry
  let content = format.content
  exe winnum . 'wincmd w'

  silent! syn clear
    \ TagListKeyword
    \ TagListVisibilityPublic
    \ TagListVisibilityPrivate
    \ TagListVisibilityProtected
    \ TagListVisibilityStatic
  for syn_cmd in format.syntax
    exec syn_cmd
  endfor

  let pos = [0, 1, 1, 0]
  " if we are updating the taglist for the same file, then preserve the
  " cursor position.
  if len(content) > 0 && getline(1) == content[0]
    let pos = getpos('.')
  endif

  setlocal modifiable
  silent 1,$delete _
  call append(1, content)
  silent retab
  silent 1,1delete _
  setlocal nomodifiable

  " if the entire taglist can fit in the window, then reposition the content
  " just in case the previous contents result in the current contents being
  " scrolled up a bit.
  if len(content) < winheight(winnr())
    normal! zb
  endif

  let b:taglisttoo_content = [format.lines, content]
  let b:taglisttoo_tags = a:tags
  let b:taglisttoo_file_bufnr = file_bufnr

  " must be after definition of buffer vars
  setlocal foldexpr=s:FoldLevel(v:lnum) foldtext=getline(v:foldstart)

  " restore any saved folds
  for path in folds
    call s:FoldPath(path)
  endfor

  call setpos('.', pos)
endfunction " }}}

function! s:ShowCurrentTag() " {{{
  if s:GetTagListWinnr() != -1 && s:FileSupported(expand('%:p'), &ft)
    let bufnr = s:GetTagListBufnr()
    let tags = getbufvar(bufnr, 'taglisttoo_tags')
    if type(tags) != 3 " something went wrong
      return
    endif
    let content = getbufvar(bufnr, 'taglisttoo_content')

    let clnum = line('.')
    let tlnum = 0
    let tindex = -1

    let index = 0
    for tag in tags
      let lnum = tag.line
      let diff = clnum - lnum
      if diff >= 0 && (diff < (clnum - tlnum))
        let tlnum = lnum
        let current = tag
        let tindex = index
      endif
      let index += 1
    endfor

    if exists('current')
      let cwinnum = winnr()
      let twinnum = s:GetTagListWinnr()

      exec 'noautocmd ' . twinnum . 'winc w'

      let index = index(content[0], tindex) + 1
      syn clear TagListCurrentTag
      exec 'syn match TagListCurrentTag "\S*\%' . index . 'l\S*"'
      if index != line('.')
        call cursor(index, 0)
        call winline()
      endif

      exec 'noautocmd ' . cwinnum . 'winc w'
    endif
  endif
endfunction " }}}

function! s:FileSupported(filename, ftype) " {{{
  " Skip buffers with no names, buffers with filetype not set, and vimballs
  if a:filename == '' || a:ftype == '' || expand('%:e') == 'vba'
    return 0
  endif

  " Skip files which are not supported by exuberant ctags
  " First check whether default settings for this filetype are available.
  " If it is not available, then check whether user specified settings are
  " available. If both are not available, then don't list the tags for this
  " filetype
  let var = 's:tlist_' . a:ftype . '_settings'
  if !exists(var)
    let var = 'g:tlist_' . a:ftype . '_settings'
    if !exists(var)
      return 0
    endif
  endif

  " Skip files which are not readable or files which are not yet stored
  " to the disk
  if !filereadable(a:filename)
    return 0
  endif

  return 1
endfunction " }}}

function! s:CloseIfLastWindow() " {{{
  if winnr('$') == 1
    if tabpagenr('$') > 1
      tabclose
    else
      quitall
    endif
  endif
endfunction " }}}

function! s:GetTagListBufnr() " {{{
  let bufnrs = tabpagebuflist()
  let bufnames = map(copy(bufnrs), 'bufname(v:val)')
  let index = index(bufnames, s:taglisttoo_title)
  if index != -1
    return bufnrs[index]
  endif
  return -1
endfunction " }}}

function! s:GetTagListWinnr() " {{{
  let bufnr = s:GetTagListBufnr()
  if bufnr != -1
    return bufwinnr(bufnr)
  endif
  return -1
endfunction " }}}

function! s:Function(name) " {{{
  try
    return function(a:name)
  catch /E700/
    " not until somewhere betwee vim 7.2 and 7.3 did vim start automatically
    " sourcing autoload files when attempting to get a funcref to an autoload
    " function, so here is our own version.
    exec 'runtime autoload/' . fnamemodify(substitute(a:name, '#', '/', 'g'), ':h') . '.vim'
    return function(a:name)
  endtry
endfunction " }}}

" vim:ft=vim:fdm=marker
