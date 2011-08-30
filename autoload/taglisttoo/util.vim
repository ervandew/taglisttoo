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

" Script Variables {{{
  let s:class = '^\(class\|interface\|object\)$'
" }}}

function! taglisttoo#util#Formatter(types, tags) " {{{
  let formatter = {
      \ 'lines': [], 'content': [], 'syntax': [],
      \ 'types': a:types, 'tags': a:tags,
      \ 'headings': [],
    \ }

  function! formatter.filename() dict " {{{
    call add(self.content, expand('%:t'))
    call add(self.lines, -1)
  endfunction " }}}

  function! formatter.format(values, indent) dict " {{{
    if type(a:values) == 4
      let tag = a:values
      call self.add(tag, a:indent)
    elseif type(a:values) == 3 && len(a:values) > 0
      call self.recurse(a:values, a:indent)
    endif
  endfunction " }}}

  function! formatter.recurse(values, indent) dict " {{{
    if !len(a:values)
      return
    endif

    if g:Tlist_Sort_Type == 'name'
      call sort(a:values, 'taglisttoo#util#SortTags', self)
    endif

    call add(self.headings, '')

    for value in a:values
      let tag_type = self.types[value.type]
      if !self.in_heading(tag_type) && tag_type !~ s:class
        call self.heading(tag_type, a:indent)
      endif

      let indent = a:indent
      if self.current_heading() != ''
        " indent tags below a heading an extra level
        let indent = a:indent . "\t"
      endif

      call self.add(value, indent)
    endfor

    let self.headings = self.headings[:-2]
  endfunction " }}}

  function! formatter.add(value, indent) dict " {{{
    let indent = a:indent
    let tag_type = self.types[a:value.type]

    let [visibility, visibility_syntax] = taglisttoo#util#GetVisibility(a:value)
    let name = a:value.name

    if tag_type =~ s:class
      let name .= ' : ' . tag_type
      " indent nested classes, but line up w/ preceding headings.
      if self.current_heading() != ''
        let indent = indent[:-2]
      endif
      " separate top level classes with a blank line
      if indent == ''
        call self.blank()
      endif
      " push the current class heading onto the stack
      if len(self.headings)
        let self.headings[-1] = tag_type
      endif
    endif

    call add(self.lines, index(self.tags, a:value))
    call add(self.content, indent . visibility . name)
    call add(self.syntax,
      \ 'syn match TagListKeyword "' . tag_type . '\%' . len(self.lines) . 'l$"')
    if visibility != ''
      call add(self.syntax,
        \ 'syn match ' . visibility_syntax .
        \ ' "^\s*\M' . visibility . '\m\%' . len(self.lines) . 'l"')
    endif

    let parent = ''
    if get(a:value, 'parent', '') != ''
      let parent = join(split(a:value.parent, ':')[1:], ':') . '.'
    endif
    let parent = tag_type . ':' . parent . a:value.name
    let nested = filter(copy(self.tags),
      \ 'get(v:val, "parent", "") == "' . parent . '"')
    call self.recurse(nested, indent . "\t")
  endfunction " }}}

  function! formatter.heading(label, indent) dict " {{{
    let self.headings[-1] = a:label
    call add(self.lines, 'label')
    call add(self.content, a:indent . a:label)
    call add(self.syntax, 'syn match TagListKeyword "^.*\%' . len(self.lines) . 'l.*"')
  endfunction " }}}

  function! formatter.in_heading(name) dict " {{{
    for h in reverse(copy(self.headings))
      if h == ''
        continue
      endif
      return h == a:name
    endfor
  endfunction " }}}

  function! formatter.current_heading() dict " {{{
    return len(self.headings) ? self.headings[-1] : ''
  endfunction " }}}

  function! formatter.blank() dict " {{{
    if len(self.headings)
      let self.headings[-1] = ''
    endif

    if self.content[-1] != ''
      call add(self.content, '')
      call add(self.lines, -1)
    endif
  endfunction " }}}

  return formatter
endfunction " }}}

function! taglisttoo#util#GetVisibility(tag) " {{{
  let pattern = a:tag.pattern
  if pattern =~ '\<public\>'
    if pattern =~ '\<static\>'
      return ['*', 'TagListVisibilityStatic']
    endif
    return ['+', 'TagListVisibilityPublic']
  elseif pattern =~ '\<protected\>'
    return ['#', 'TagListVisibilityProtected']
  elseif pattern =~ '\<private\>'
    return ['-', 'TagListVisibilityPrivate']
  endif
  return ['', '']
endfunction " }}}

function! taglisttoo#util#Parse(file, patterns) " {{{
python << PYTHONEOF
filename = vim.eval('a:file')
patterns = vim.eval('a:patterns')
result = taglisttoo.parse(filename, patterns)
vim.command('let results = %s' % ('%r' % result).replace("\\'", "''"))
PYTHONEOF

  let tags = []
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

  return tags
endfunction " }}}

function! taglisttoo#util#SortTags(tag1, tag2) dict " {{{
  let type1 = self.types[a:tag1.type]
  let type2 = self.types[a:tag2.type]

  if type1 != type2
    if type1 =~ s:class && type2 !~ s:class
      return 1
    elseif type1 !~ s:class && type2 =~ s:class
      return -1
    endif

    return type1 > type2 ? 1 : -1
  endif

  let name1 = tolower(a:tag1.name)
  let name2 = tolower(a:tag2.name)
  return name1 == name2 ? 0 : name1 > name2 ? 1 : -1
endfunction " }}}

" vim:ft=vim:fdm=marker
