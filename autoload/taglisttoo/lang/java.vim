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
function! taglisttoo#lang#java#Format(types, tags)
  let formatter = taglisttoo#util#Formatter(a:tags)
  call formatter.filename()

  let package = filter(copy(a:tags), 'v:val.type == "p"')
  call formatter.format(a:types['p'], package, '')

  let classes = filter(copy(a:tags), 'v:val.type == "c"')

  " sort classes alphabetically except for the primary containing class.
  if len(classes) > 1 && g:Tlist_Sort_Type == 'name'
    let classes = [classes[0]] + sort(classes[1:], 'taglisttoo#util#SortTags')
  endif

  for class in classes
    call formatter.blank()

    let visibility = taglisttoo#util#GetVisibility(class)
    call formatter.heading(a:types['c'], class, '')

    let fields = filter(copy(a:tags),
      \ 'v:val.type == "f" && v:val.parent =~ "class:.*\\<" . class.name . "$"')
    call formatter.format(a:types['f'], fields, "\t")

    let methods = filter(copy(a:tags),
      \ 'v:val.type == "m" && v:val.parent =~ "class:.*\\<" . class.name . "$"')
    call formatter.format(a:types['m'], methods, "\t")
  endfor

  let interfaces = filter(copy(a:tags), 'v:val.type == "i"')
  if g:Tlist_Sort_Type == 'name'
    call sort(interfaces, 'taglisttoo#util#SortTags')
  endif
  for interface in interfaces
    call formatter.blank()

    let visibility = taglisttoo#util#GetVisibility(interface)
    call formatter.heading(a:types['i'], interface, '')

    let fields = filter(copy(a:tags),
      \ 'v:val.type == "f" && v:val.parent =~ "interface:.*\\<" . interface.name . "$"')
    call formatter.format(a:types['f'], fields, "\t")

    let methods = filter(copy(a:tags),
      \ 'v:val.type == "m" && v:val.parent =~ "interface:.*\\<" . interface.name . "$"')
    call formatter.format(a:types['m'], methods, "\t")
  endfor

  return formatter
endfunction " }}}

" vim:ft=vim:fdm=marker
