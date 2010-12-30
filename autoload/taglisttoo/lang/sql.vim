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

" Parse(file, settings) {{{
function! taglisttoo#lang#sql#Parse(file, settings)
  return taglisttoo#util#Parse(a:file, [
      \ ['g', 'create\s+(?:group|role)\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['u', 'create\s+user\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['p', 'create\s+(?:tablespace|dbspace)\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['s', 'create\s+schema\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['t', 'create\s+(?:temporary\s+)?table\s+(?:if\s+not\s+exists\s+)?[`]?([a-zA-Z0-9_.]+)[`]?', 1, 'i'],
      \ ['v', 'create\s+(?:or\s+replace\s+)?view\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['q', 'create\s+sequence\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['x', 'create\s+(?:or\s+replace\s+)?trigger\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['f', 'create\s+(?:or\s+replace\s+)?function\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['c', 'create\s+(?:or\s+replace\s+)?procedure\s+([a-zA-Z0-9_.]+)', 1, 'i'],
      \ ['r', "exec\\s+sp_addrole\\s+['\"]([a-zA-Z0-9_.]+)['\"]", 1, 'i'],
      \ ['m', "exec\\s+sp_addlogin\\s+@loginname=['\"](.*?)['\"]", 1, 'i'],
      \ ['z', 'alter\s+database.*add\s+filegroup\s+([a-zA-Z0-9_.]+)', 1, 'i'],
    \ ])
endfunction " }}}

" vim:ft=vim:fdm=marker
