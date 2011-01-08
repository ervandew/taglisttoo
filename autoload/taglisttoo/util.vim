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

function! taglisttoo#util#Formatter(tags) " {{{
  let formatter = {'lines': [], 'content': [], 'syntax': [], 'tags': a:tags}

  function! formatter.filename() dict " {{{
    call add(self.content, expand('%:t'))
    call add(self.lines, -1)
  endfunction " }}}

  function! formatter.format(type, values, indent) dict " {{{
    if len(a:values) > 0
      if g:Tlist_Sort_Type == 'name'
        call sort(a:values, 'taglisttoo#util#SortTags')
      endif

      call self.heading(a:type, {}, a:indent)

      for value in a:values
        let visibility = taglisttoo#util#GetVisibility(value)
        call add(self.content, "\t" . a:indent . visibility . value.name)
        call add(self.lines, index(self.tags, value))
      endfor
    endif
  endfunction " }}}

  function! formatter.heading(type, tag, indent) dict " {{{
    if len(a:tag)
      call add(self.lines, index(self.tags, a:tag))
      call add(self.content, a:indent . a:type . ' ' . a:tag.name)
      call add(self.syntax,
        \ 'syn match TagListKeyword "^\s*' . a:type . '\%' . len(self.lines) . 'l"')
    else
      call add(self.lines, 'label')
      call add(self.content, a:indent . a:type)
      call add(self.syntax, 'syn match TagListKeyword "^.*\%' . len(self.lines) . 'l.*"')
    endif
  endfunction " }}}

  function! formatter.blank() dict " {{{
    call add(self.content, '')
    call add(self.lines, -1)
  endfunction " }}}

  return formatter
endfunction " }}}

function! taglisttoo#util#GetVisibility(tag) " {{{
  let pattern = a:tag.pattern
  if pattern =~ '\<public\>'
    if pattern =~ '\<static\>'
      return '*'
    endif
    return '+'
  elseif pattern =~ '\<protected\>'
    return '#'
  elseif pattern =~ '\<private\>'
    return '-'
  endif
  return ''
endfunction " }}}

function! taglisttoo#util#Parse(file, patterns) " {{{
python << PYTHONEOF
filename = vim.eval('a:file')
patterns = vim.eval('a:patterns')
result = taglisttoo.parse(filename, patterns)
vim.command('let result = %s' % ('%r' % result).replace("\\'", "''"))
PYTHONEOF

return result
endfunction " }}}

function! taglisttoo#util#SortTags(tag1, tag2) " {{{
  return a:tag1.name == a:tag2.name ? 0 : a:tag1.name > a:tag2.name ? 1 : -1
endfunction " }}}

" vim:ft=vim:fdm=marker
