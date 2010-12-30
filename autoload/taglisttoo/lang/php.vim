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
function! taglisttoo#lang#php#Format(types, tags)
  let pos = getpos('.')

  let formatter = taglisttoo#util#Formatter(a:tags)
  call formatter.filename()

  let top_functions = filter(copy(a:tags), 'v:val.type == "f"')

  let class_contents = []
  let classes = filter(copy(a:tags), 'v:val.type == "c"')
  if g:Tlist_Sort_Type == 'name'
    call sort(classes, 'taglisttoo#util#SortTags')
  endif
  for class in classes
    let object_start = class.line
    call cursor(object_start, 1)
    call search('{', 'W')
    let object_end = searchpair('{', '', '}', 'W')

    let functions = []
    let indexes = []
    let index = 0
    for fct in top_functions
      if len(fct) > 3
        let fct_line = fct.line
        if fct_line > object_start && fct_line < object_end
          call add(functions, fct)
          call add(indexes, index)
        endif
      endif
      let index += 1
    endfor
    call reverse(indexes)
    for i in indexes
      call remove(top_functions, i)
    endfor

    call add(class_contents, {'class': class, 'functions': functions})
  endfor

  let interface_contents = []
  let interfaces = filter(copy(a:tags), 'v:val.type == "i"')
  if g:Tlist_Sort_Type == 'name'
    call sort(interfaces, 'taglisttoo#util#SortTags')
  endif
  for interface in interfaces
    let object_start = interface.line
    call cursor(object_start, 1)
    call search('{', 'W')
    let object_end = searchpair('{', '', '}', 'W')

    let functions = []
    let indexes = []
    let index = 0
    for fct in top_functions
      if len(fct) > 3
        let fct_line = fct.line
        if fct_line > object_start && fct_line < object_end
          call add(functions, fct)
          call add(indexes, index)
        endif
      endif
      let index += 1
    endfor
    call reverse(indexes)
    for i in indexes
      call remove(top_functions, i)
    endfor

    call add(interface_contents, {'interface': interface, 'functions': functions})
  endfor

  if len(top_functions) > 0
    call formatter.blank()
    call formatter.format(a:types['f'], top_functions, '')
  endif

  for class_content in class_contents
    call formatter.blank()
    call formatter.heading(a:types['c'], class_content.class, '')
    call formatter.format(a:types['f'], class_content.functions, "\t")
  endfor

  for interface_content in interface_contents
    call formatter.blank()
    call formatter.heading(a:types['i'], interface_content.interface, '')
    call formatter.format(a:types['f'], interface_content.functions, "\t")
  endfor

  call setpos('.', pos)

  return formatter
endfunction " }}}

" Parse(file, settings) {{{
function! taglisttoo#lang#php#Parse(file, settings)
  return taglisttoo#util#Parse(a:file, [
      \ ['f', '\bfunction\s+([a-zA-Z0-9_]+)\s*\(', 1],
      \ ['c', '\bclass\s+([a-zA-Z0-9_]+)', 1],
      \ ['i', '\binterface\s+([a-zA-Z0-9_]+)', 1],
    \ ])
endfunction " }}}

" vim:ft=vim:fdm=marker
