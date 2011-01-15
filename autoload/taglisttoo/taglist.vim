" Author:  Eric Van Dewoestine
"
" License: {{{
"   Copyright (c) 2005 - 2011, Eric Van Dewoestine
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
  let s:taglisttoo_title_escaped =
    \ substitute(s:taglisttoo_title, '\(.\{-}\)\[\(.\{-}\)\]\(.\{-}\)', '\1[[]\2[]]\3', 'g')
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
    \ 'lang': 'c++', 'tags': {
      \ 'n': 'namespace',
      \ 'v': 'variable',
      \ 'd': 'macro',
      \ 't': 'typedef',
      \ 'c': 'class',
      \ 'g': 'enum',
      \ 's': 'struct',
      \ 'u': 'union',
      \ 'f': 'function'
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
    \ 'format': 'taglisttoo#lang#java#Format',
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
    \ 'format': 'taglisttoo#lang#javascript#Format',
    \ 'parse': 'taglisttoo#lang#javascript#Parse',
    \ 'tags': {
      \ 'o': 'object',
      \ 'm': 'member',
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
    \ 'lang': 'perl', 'tags': {
      \ 'c': 'constant',
      \ 'l': 'label',
      \ 'p': 'package',
      \ 's': 'subroutine'
    \ }
  \ }

" php language
let s:tlist_php_settings = {
    \ 'lang': 'php',
    \ 'format': 'taglisttoo#lang#php#Format',
    \ 'parse': 'taglisttoo#lang#php#Parse',
    \ 'tags': {
      \ 'c': 'class',
      \ 'd': 'constant',
      \ 'v': 'variable',
      \ 'f': 'function'
    \ }
  \ }

" python language
let s:tlist_python_settings = {
    \ 'lang': 'python',
    \ 'format': 'taglisttoo#lang#python#Format',
    \ 'tags': {
      \ 'c': 'class',
      \ 'm': 'member',
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
      \ 'f': 'method',
      \ 'F': 'function',
      \ 'm': 'singleton method'
    \ }
  \ }

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
    \ 'lang': 'vim', 'tags': {
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
  endif
endfunction " }}}

" Taglist([action]) {{{
" action
"   - not supplied (or -1): toggle
"   - 1: open
"   - 0: close
function! taglisttoo#taglist#Taglist(...)
  if !exists('g:Tlist_Ctags_Cmd')
    call s:EchoError('Unable to find a version of ctags installed.')
    return
  endif

  call s:Init()

  if bufname('%') == s:taglisttoo_title
    call s:CloseTaglist()
    return
  endif

  let action = len(a:000) ? a:000[0] : -1

  if action == -1 || action == 0
    let winnum = bufwinnr(s:taglisttoo_title_escaped)
    if winnum != -1
      let prevbuf = bufnr('%')
      exe winnum . 'wincmd w'
      call s:CloseTaglist()
      exec bufwinnr(prevbuf) . 'wincmd w'
      return
    endif
  endif

  if action == -1 || action == 1
    call s:ProcessTags(1)
    call s:StartAutocmds()

    augroup taglisttoo
      autocmd!
      exec 'autocmd BufUnload ' .
        \ escape(s:taglisttoo_title_escaped, ' ') . ' call s:Cleanup()'
      autocmd CursorHold * call s:ShowCurrentTag()
    augroup END
  endif
endfunction " }}}

" Restore() {{{
" Restore the taglist, typically after loading from a session file.
function! taglisttoo#taglist#Restore()
  if exists('t:taglistoo_restoring')
    return
  endif
  let t:taglistoo_restoring = 1

  " prevent auto open from firing after session is loaded.
  augroup taglisttoo_autoopen
    autocmd!
  augroup END

  let winnum = bufwinnr(s:taglisttoo_title_escaped)
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
  augroup taglisttoo_file
    autocmd!
    exec 'autocmd CursorHold,CursorMoved ' .
      \ escape(s:taglisttoo_title_escaped, ' ') . ' call s:EchoTag()'
    exec 'autocmd BufEnter ' .
      \ escape(s:taglisttoo_title_escaped, ' ') . '  nested call s:CloseIfLastWindow()'
    autocmd BufEnter *
      \ if bufwinnr(s:taglisttoo_title_escaped) != -1 |
      \   call s:ProcessTags(0) |
      \ endif
    autocmd BufWritePost *
      \ if bufwinnr(s:taglisttoo_title_escaped) != -1 |
      \   call s:ProcessTags(1) |
      \ endif
    " bit of a hack to re-process tags if the filetype changes after the tags
    " have been processed.
    autocmd FileType *
      \ if exists('b:ft') |
      \   if b:ft != &ft |
      \     if bufwinnr(s:taglisttoo_title_escaped) != -1 |
      \       call s:ProcessTags(1) |
      \     endif |
      \     let b:ft = &ft |
      \   endif |
      \ else |
      \   let b:ft = &ft |
      \ endif
    autocmd WinLeave *
      \ if bufwinnr(s:taglisttoo_title_escaped) != -1 && &buftype == '' |
      \   let s:taglisttoo_prevwinnr = winnr() |
      \ endif
  augroup END
endfunction " }}}

function! s:CloseTaglist() " {{{
  close
  call s:Cleanup()
endfunction " }}}

function! s:Cleanup() " {{{
  augroup taglisttoo_file
    autocmd!
  augroup END

  augroup taglisttoo
    autocmd!
  augroup END

  " TODO: clear all b:taglisttoo_folds variables?
endfunction " }}}

function! s:ProcessTags(on_open_or_write) " {{{
  " on insert completion prevent vim's jumping back and forth from the
  " completion preview window from triggering a re-processing of tags
  if pumvisible()
    return
  endif

  " if we are entering a buffer whose taglist list is already loaded, then
  " don't do anything.
  if !a:on_open_or_write
    let bufnr = bufnr(s:taglisttoo_title_escaped)
    let filebuf = getbufvar(bufnr, 'taglisttoo_file_bufnr')
    if filebuf == bufnr('%')
      return
    endif
  endif

  let filename = expand('%:p')
  if filename == '' || &buftype != ''
    return
  endif
  let filewin = winnr()

  let tags = []
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
        let results = function(settings.parse)(file, settings)
      else
        let results = s:Parse(file, settings)
      endif
    finally
      if tempfile != ''
        call delete(tempfile)
      endif
    endtry

    if type(results) != 3
      return
    endif

    if len(results)
      for result in results
        " filter false positives found in comments or strings
        let lnum = result.line
        let line = getline(lnum)
        let col = len(line) - len(substitute(line, '^\s*', '', '')) + 1
        if synIDattr(synID(lnum, col, 1), 'name') =~? '\(comment\|string\)' ||
         \ synIDattr(synIDtrans(synID(lnum, col, 1)), 'name') =~? '\(comment\|string\)'
          continue
        endif

        call add(tags, result)
      endfor
    endif

    call s:Window(settings, tags)

    " if the file buffer is no longer in the same window it was, then find its
    " new location. Occurs when taglist first opens.
    if winbufnr(filewin) != bufnr(filename)
      let filewin = bufwinnr(filename)
    endif

    if filewin != -1
      exec filewin . 'winc w'
    endif
  else
    " if the file isn't supported, then don't open the taglist window if it
    " isn't open already.
    let winnum = bufwinnr(s:taglisttoo_title_escaped)
    if winnum != -1
      call s:Window({'tags': {}}, tags)
      winc p
    endif
  endif

  call s:ShowCurrentTag()
endfunction " }}}

function! s:Parse(filename, settings) " {{{
python << PYTHONEOF
settings = vim.eval('a:settings')
filename = vim.eval('a:filename')
lang = settings['lang']
types = ''.join(settings['tags'].keys())

retcode, result = taglisttoo.ctags(lang, types, filename)
vim.command('let retcode = %i' % retcode)
vim.command("let result = '%s'" % result.replace("'", "''"))
PYTHONEOF

  if retcode
    call s:EchoError('taglist failed with error code: ' . retcode)
    return
  endif

  if has('win32') || has('win64') || has('win32unix')
    let result = substitute(result, "\<c-m>\n", '\n', 'g')
  endif

  let results = split(result, '\n')
  while len(results) && results[0] =~ 'ctags.*: Warning:'
    call remove(results, 0)
  endwhile

  let types = keys(a:settings.tags)
  let parsed_results = []
  for result in results
    let pre = substitute(result, '\(.\{-}\)\t\/\^.*', '\1', '')
    let pattern = substitute(result, '.\{-}\(\/\^.*\/;"\).*', '\1', '')
    let post = substitute(result, '.\{-}\/\^.*\/;"\t', '', '')

    let [name, filename] = split(pre, '\t')
    let parts = split(post, '\t')
    let [type, line_str] = parts[:1]
    exec 'let line = ' . substitute(line_str, 'line:', '', '')
    let pattern = substitute(pattern, '^/\(.*\)/;"$', '\1', '')
    let parent = len(parts) > 2 ? parts[2] : ''

    " ctags (mine at least) is not properly honoring --<lang>-kinds, so
    " perform our own check here.
    if index(types, type) != -1
      call add(parsed_results, {
          \ 'type': type,
          \ 'name': name,
          \ 'pattern': pattern,
          \ 'line': line,
          \ 'parent': parent,
        \ })
    endif
  endfor

  return parsed_results
endfunction " }}}

function! s:FormatDefault(types, tags) " {{{
  let formatter = taglisttoo#util#Formatter(a:tags)
  call formatter.filename()

  for key in keys(a:types)
    let values = filter(copy(a:tags), 'v:val.type == key')
    if len(values)
      call formatter.blank()
    endif
    call formatter.format(a:types[key], values, "")
  endfor

  return formatter
endfunction " }}}

function! s:FormatEmpty(types, tags) " {{{
  return taglisttoo#util#Formatter(a:tags)
endfunction " }}}

function! s:GetTagInfo() " {{{
  if line('.') > len(b:taglisttoo_content[0])
    return []
  endif

  let index = b:taglisttoo_content[0][line('.') - 1]
  if index == -1
    return []
  endif

  return b:taglisttoo_tags[index]
endfunction " }}}

function! s:EchoError(message) " {{{
  echohl Error
  echo a:message
  echohl Normal
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
  let indent = indent(a:lnum)
  let next_line = nextnonblank(a:lnum + 1)
  if next_line
    let next_indent = indent(next_line)
    if next_indent > indent
      let indent = next_indent
    endif
  endif
  let level = indent / &shiftwidth
  return level
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
    let col = len(line) - len(substitute(line, '^\s*', '', '')) + 1
    let syntax = synIDattr(synID(fold, col, 1), 'name')
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
    let col = len(line) - len(substitute(line, '^\s*', '', '')) + 1
    let syntax = synIDattr(synID(lnum, col, 1), 'name')
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

function! s:JumpToTag() " {{{
  let tag_info = s:GetTagInfo()
  if !len(tag_info)
    return
  endif

  " handle case of buffer open in multiple windows.
  if s:taglisttoo_prevwinnr &&
   \ winbufnr(s:taglisttoo_prevwinnr) == b:taglisttoo_file_bufnr
    noautocmd exec s:taglisttoo_prevwinnr . 'winc w'
  else
    noautocmd exec bufwinnr(b:taglisttoo_file_bufnr) . 'winc w'
  endif

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
endfunction " }}}

function! s:Window(settings, tags) " {{{
  let file_bufnr = bufnr('%')
  let folds = exists('b:taglisttoo_folds') ? b:taglisttoo_folds : []

  let buffers = {}
  for bufnum in tabpagebuflist()
    let name = bufname(bufnum)
    if name != ''
      let buffers[bufname(bufnum)] = bufnum
    endif
  endfor

  if has_key(buffers, s:taglisttoo_title)
    let winnum = bufwinnr(buffers[s:taglisttoo_title])
  else
    if exists('g:VerticalToolWindowSide') &&
     \ g:VerticalToolWindowSide == g:TaglistTooPosition
      call eclim#display#window#VerticalToolWindowOpen(s:taglisttoo_title, 10, 1)
    else
      let position = g:TaglistTooPosition == 'right' ? 'botright' : 'topleft'
      silent exec
        \ position . ' vertical ' . g:Tlist_WinWidth .
        \ ' split ' . escape(s:taglisttoo_title, ' ')
    endif

    let winnum = winnr()

    setlocal filetype=taglist
    setlocal buftype=nofile bufhidden=delete
    setlocal noswapfile nobuflisted
    setlocal expandtab shiftwidth=2 tabstop=2
    setlocal winfixwidth
    setlocal nowrap nonumber
    setlocal foldmethod=expr foldlevel=99
    setlocal foldexpr=s:FoldLevel(v:lnum) foldtext=getline(v:foldstart)

    syn match TagListFileName "^.*\%1l.*"
    hi link TagListFileName Identifier
    hi link TagListKeyword Statement
    hi TagListCurrentTag term=bold,underline cterm=bold,underline gui=bold,underline

    nnoremap <silent> <buffer> <cr> :call <SID>JumpToTag()<cr>

    " folding related mappings
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
    if g:Tlist_Sort_Type == 'name'
      call sort(a:tags, 'taglisttoo#util#SortTags')
    endif
    let formatter = 's:FormatDefault'
  else
    let formatter = 's:FormatEmpty'
  endif

  let format = function(formatter)(a:settings.tags, a:tags)
  let content = format.content
  exe winnum . 'wincmd w'

  silent! syn clear TagListKeyword
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

  " restore any saved folds
  for path in folds
    call s:FoldPath(path)
  endfor

  call setpos('.', pos)

  " if the entire taglist can fit in the window, then reposition the content
  " just in case the previous contents result in the current contents being
  " scrolled up a bit.
  if len(content) < winheight(winnr())
    normal! zb
  endif

  let b:taglisttoo_content = [format.lines, content]
  let b:taglisttoo_tags = a:tags
  let b:taglisttoo_file_bufnr = file_bufnr
endfunction " }}}

function! s:ShowCurrentTag() " {{{
  if s:FileSupported(expand('%:p'), &ft) && bufwinnr(s:taglisttoo_title_escaped) != -1
    let tags = getbufvar(s:taglisttoo_title_escaped, 'taglisttoo_tags')
    let content = getbufvar(s:taglisttoo_title_escaped, 'taglisttoo_content')

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
      let twinnum = bufwinnr(s:taglisttoo_title_escaped)

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
  if histget(':', -1) !~ '^bd'
    let numtoolwindows = 0
    if winnr('$') == 1
      if tabpagenr('$') > 1
        tabclose
      else
        quitall
      endif
    endif
  endif
endfunction " }}}

" vim:ft=vim:fdm=marker
