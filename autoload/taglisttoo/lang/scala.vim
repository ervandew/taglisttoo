" Author:  Eric Van Dewoestine
"
" License: {{{
"   Copyright (c) 2011, Eric Van Dewoestine
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

" Parse(file, settings) {{{
function! taglisttoo#lang#scala#Parse(file, settings)
  let tags = taglisttoo#util#Parse(a:file, a:settings, [
      \ ['p', '\bpackage\s+([a-zA-Z0-9_.]+)', 1],
      \ ['c', '\bclass\s+([a-zA-Z0-9_]+)', 1],
      \ ['o', '\bobject\s+([a-zA-Z0-9_]+)', 1],
      \ ['t', '\btrait\s+([a-zA-Z0-9_]+)', 1],
      \ ['T', '\btype\s+([a-zA-Z0-9_]+)', 1],
      \ ['m', '\bdef\s+([a-zA-Z0-9_\?]+)', 1],
      \ ['C', '\bval\s+([a-zA-Z0-9_]+)', 1],
      \ ['l', '\bvar\s+([a-zA-Z0-9_]+)', 1],
    \ ])

  call taglisttoo#util#SetNestedParents(
    \ a:settings.tags, tags, ['c', 'o', 't', 'm'], '{', '}')

  return tags
endfunction " }}}

" vim:ft=vim:fdm=marker
