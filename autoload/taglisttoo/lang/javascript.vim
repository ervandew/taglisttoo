" Author:  Eric Van Dewoestine
"
" License: {{{
"   Copyright (c) 2005 - 2010, Eric Van Dewoestine
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

" Format(types, tags) {{{
function! taglisttoo#lang#javascript#Format(types, tags)
  let pos = getpos('.')

  let formatter = taglisttoo#util#Formatter(a:tags)
  call formatter.filename()

  let object_contents = []

  let objects = filter(copy(a:tags), 'v:val.type == "o"')
  let members = filter(copy(a:tags), 'v:val.type == "m"')
  let functions = filter(copy(a:tags),
    \ 'v:val.type == "f" && v:val.pattern =~ "\\<function\\>"')
  let object_bounds = {}
  for object in objects
    let object_start = object.line
    call cursor(object_start, 1)
    while search('{', 'W') && s:SkipComments()
      " no op
    endwhile
    let object_end = searchpair('{', '', '}', 'W', 's:SkipComments()')

    let methods = []
    let indexes = []
    let index = 0
    for fct in members
      if len(fct) > 3
        let fct_line = fct.line
        if fct_line > object_start && fct_line < object_end
          call add(methods, fct)
        elseif fct_line > object_end
          break
        elseif fct_line < object_end
          call add(indexes, index)
        endif
      endif
      let index += 1
    endfor
    call reverse(indexes)
    for i in indexes
      call remove(members, i)
    endfor

    let indexes = []
    let index = 0
    for fct in functions
      if len(fct) > 3
        let fct_line = fct.line
        if fct_line > object_start && fct_line < object_end
          call add(methods, fct)
          call add(indexes, index)
        elseif fct_line == object_start
          call add(indexes, index)
        elseif fct_line > object_end
          break
        endif
      endif
      let index += 1
    endfor
    call reverse(indexes)
    for i in indexes
      call remove(functions, i)
    endfor

    if len(methods) > 0
      let parent_object = s:GetParentObject(
        \ object_contents, object_bounds, object_start, object_end)
      " remove methods from the parent if necessary
      if len(parent_object)
        call filter(parent_object.methods, 'index(methods, v:val) == -1')
      endif
      let object_bounds[string(object)] = [object_start, object_end]
      call add(object_contents, {'object': object, 'methods': methods})
    endif
  endfor

  if len(functions) > 0
    call formatter.blank()
    call formatter.format(a:types['f'], functions, '')
  endif

  if g:Tlist_Sort_Type == 'name'
    call sort(object_contents, function('s:ObjectComparator'))
  endif

  for object_content in object_contents
    call formatter.blank()
    call formatter.heading(a:types['o'], object_content.object, '')
    call formatter.format(a:types['f'], object_content.methods, "\t")
  endfor

  call setpos('.', pos)

  return formatter
endfunction " }}}

" Parse(file, settings) {{{
function! taglisttoo#lang#javascript#Parse(file, settings)
  let patterns = []
  " Match Objects/Classes
  call add(patterns, ['o', '([A-Za-z0-9_.]+)\s*=\s*\{(\s*[^}]|$)', 1])

  " prototype.js has Object.extend to extend existing objects.
  call add(patterns, ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*Object\.extend\s*\(', 1])
  call add(patterns, ['o', '\bObject\.extend\s*\(\b([A-Z][A-Za-z0-9_.]+)\s*,\s*\{', 1])

  " mootools uses 'new Class'
  call add(patterns, ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*new\s+Class\s*\(', 1])

  " firebug uses extend
  call add(patterns, ['o', '(?:var\s+)?\b([A-Z][A-Za-z0-9_.]+)\s*=\s*extend\s*\(', 1])

  " vimperator uses function MyClass ()
  call add(patterns, ['o', 'function\s+\b([A-Z][A-Za-z0-9_.]+)\s*\(', 1])
  " vimperator uses var = (function()
  call add(patterns, ['o', '([A-Za-z0-9_.]+)\s*=\s*\(function\s*\(', 1])

  " Match Functions
  call add(patterns, ['f', '\bfunction\s+([a-zA-Z0-9_.\$]+?)\s*\(', 1])
  call add(patterns, ['f', '([a-zA-Z0-9_.\$]+?)\s*=\s*function\s*\(', 1])

  " Match Members
  call add(patterns, ['m', '\b([a-zA-Z0-9_.\$]+?)\s*:\s*function\s*\(', 1])
  return taglisttoo#util#Parse(a:file, patterns)
endfunction " }}}

" s:ObjectComparator(o1, o2) {{{
function s:ObjectComparator(o1, o2)
  let n1 = a:o1['object'].name
  let n2 = a:o2['object'].name
  return n1 == n2 ? 0 : n1 > n2 ? 1 : -1
endfunction " }}}

" s:SkipComments() {{{
function s:SkipComments()
  let synname = synIDattr(synID(line('.'), col('.'), 1), "name")
  return synname =~? '\(comment\|string\)'
endfunction " }}}

" s:GetParentObject(objects, bounds, start, end) {{{
function s:GetParentObject(objects, bounds, start, end)
  for key in keys(a:bounds)
    let range = a:bounds[key]
    if range[0] < a:start && range[1] > a:end
      for object_content in a:objects
        if string(object_content.object) == key
          return object_content
        endif
      endfor
      break
    endif
  endfor
  return {}
endfunction " }}}

" vim:ft=vim:fdm=marker
