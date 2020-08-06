" Author:  Eric Van Dewoestine
"
" License: {{{
"   Copyright (c) 2005 - 2020, Eric Van Dewoestine
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

" Global Variabls {{{
if !exists('g:TaglistTooJSctags')
  let g:TaglistTooJSctags = 1
endif
" }}}

function! taglisttoo#lang#javascript#Parse(file, settings) " {{{
  if g:TaglistTooJSctags && !exists('g:Tlist_JSctags_Cmd')
    if executable('jsctags')
      let g:Tlist_JSctags_Cmd = 'jsctags'
    elseif executable('javascripttags')
      let g:Tlist_JSctags_Cmd = 'javascripttags'
    endif
  endif

  if !g:TaglistTooJSctags || !exists('g:Tlist_JSctags_Cmd')
    return s:ParseRegex(a:file, a:settings)
  endif
  return s:ParseJSctags(a:file, a:settings)
endfunction " }}}

function! s:ParseJSctags(file, settings) " {{{
python3 << PYTHONEOF
retcode, result = taglisttoo.jsctags(vim.eval('a:file'))
vim.command('let retcode = %i' % retcode)
vim.command("let result = '%s'" % result.replace("'", "''"))
PYTHONEOF

  if retcode
    call taglisttoo#util#EchoError('jsctags failed with error code: ' . retcode)
    return
  endif

  if has('win32') || has('win64') || has('win32unix')
    let result = substitute(result, "\<c-m>\n", '\n', 'g')
  endif

  let results = split(result, '\n')
  while len(results) && results[0] =~ '^!_'
    call remove(results, 0)
  endwhile

  let types = keys(a:settings.tags)
  let parsed_results = []
  for result in results
    " some results use <lnum>G;" (e.g. 1956G;") as the pattern... skip those
    " for now since taglist expects actual patterns.
    if result !~ '\t\/\^'
      continue
    endif

    let pre = substitute(result, '\(.\{-}\)\t\/\^.*', '\1', '')
    let pattern = substitute(result, '.\{-}\(\/\^.*\/;"\).*', '\1', '')
    let post = substitute(result, '.\{-}\/\^.*\/;"\t', '', '')

    let [name, filename] = split(pre, '\t')
    let parts = split(post, '\t')
    let [type, line_str] = parts[:1]
    exec 'let line = ' . substitute(line_str, 'lineno:', '', '')
    let pattern = substitute(pattern, '^/\(.*\)/;"$', '\1', '')

    let jstypes = filter(copy(parts), 'v:val =~ "^type:"')
    let namespaces = filter(copy(parts), 'v:val =~ "^namespace:"')

    let jstype = len(jstypes) ? substitute(jstypes[0], '^type:', '', '') : ''
    let ns = len(namespaces) ? substitute(namespaces[0], '^namespace:', '', '') : ''

    call add(parsed_results, {
        \ 'type': type,
        \ 'name': name,
        \ 'pattern': pattern,
        \ 'line': line,
        \ 'namespace': ns,
        \ 'jstype': jstype,
      \ })
  endfor

  return parsed_results
endfunction " }}}

function! s:ParseRegex(file, settings) " {{{
  let patterns = []
  " Match Objects/Classes
  call add(patterns, ['o', '([A-Za-z0-9_.]+)\s*=\s*\{(\s*[^}]|$)', 1])

  " prototype.js has Object.extend to extend existing objects.
  call add(patterns, ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*Object\.extend\s*\(', 1])

  " mootools uses 'new Class'
  call add(patterns, ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*new\s+Class\s*\(', 1])

  " firebug uses extend
  call add(patterns, ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*extend\s*\(', 1])

  " vimperator uses function MyClass ()
  call add(patterns, ['o', 'function\s+\b([A-Z][A-Za-z0-9_.]+)\s*\(', 1])
  " vimperator uses var = (function()
  call add(patterns, ['o', '([A-Za-z0-9_.]+)\s*=\s*\(function\s*\(', 1])

  " other library based exend calls (backbone, etc)
  call add(patterns,
    \ ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*[A-Za-z0-9_.]+\.extend\s*\({', 1])
  call add(patterns, ['o', '\.extend\s*\(\b([A-Z][A-Za-z0-9_.]+)\s*,\s*\{', 1])

  " Match Functions
  call add(patterns, ['f', '\bfunction\s+([a-zA-Z0-9_.\$]+?)\s*\(', 1])
  call add(patterns, ['f', '([a-zA-Z0-9_.\$]+?)\s*=\s*\(?function\s*\(', 1])
  call add(patterns, ['f', "\\[[\"']([A-Za-z0-9_]+)[\"']\\]\\s*=\\s*\\(?function\\s*\\(", 1])

  " Match Members
  call add(patterns, ['f', '\b([a-zA-Z0-9_.\$]+?)\s*:\s*function\s*\(', 1])
  let tags = taglisttoo#util#Parse(a:file, a:settings, patterns)

  call taglisttoo#util#SetNestedParents(
    \ a:settings.tags, tags, ['o', 'f', 'm'], '{', '}')

  return tags
endfunction " }}}

" vim:ft=vim:fdm=marker
