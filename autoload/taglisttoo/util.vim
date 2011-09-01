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
  let s:class = '^\(class\|interface\|object\|package\|namespace\|struct\)$'
" }}}

function! taglisttoo#util#Formatter(settings, tags) " {{{
  let formatter = {
      \ 'lines': [], 'content': [], 'syntax': [], 'headings': [],
      \ 'settings': a:settings, 'types': a:settings.tags,
      \ 'tags': a:tags,
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
      call sort(a:values, 's:SortTagsByName', self)
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
      let parent_type = substitute(a:value.parent, '^\(.\{-}\):.*', '\1', '')
      let parent_name = substitute(a:value.parent, '^.\{-}:\(.*\)', '\1', '')
      let parent = parent_name . get(self.settings, 'separator', '.')
    endif
    let parent = tag_type . ':' . parent . a:value.name
    let lnum = a:value.line
    let nested = filter(copy(self.tags),
      \ 'get(v:val, "parent", "") == parent && v:val.line > lnum')
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
  let name = escape(a:tag.name, '~')
  if pattern =~ '\<public\>.*' . name
    if pattern =~ '\<static\>.*' . name
      return ['*', 'TagListVisibilityStatic']
    endif
    return ['+', 'TagListVisibilityPublic']
  elseif pattern =~ '\<protected\>.*' . name
    return ['#', 'TagListVisibilityProtected']
  elseif pattern =~ '\<private\>.*' . name
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

  call sort(tags, 's:SortTagsByLine')

  return tags
endfunction " }}}

function! taglisttoo#util#ParseCtags(filename, settings) " {{{
python << PYTHONEOF
try:
  settings = vim.eval('a:settings')
  filename = vim.eval('a:filename')
  lang = settings['lang']
  types = ''.join(settings['tags'].keys())

  retcode, result = taglisttoo.ctags(lang, types, filename)
  vim.command('let retcode = %i' % retcode)
  vim.command("let result = '%s'" % result.replace("'", "''"))
except Exception as e:
  vim.command("call s:EchoError('%s')" % str(e).replace("'", "''"))
  vim.command('let retcode = -1')
PYTHONEOF

  if retcode
    if retcode != -1
      call s:EchoError('taglist failed with error code: ' . retcode)
    endif
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

function! taglisttoo#util#SetNestedParents(types, tags, parent_types, parent_pair_start, parent_pair_end) " {{{
  let pos = getpos('.')

  let parents = []

  for tag in a:tags
    " pop off any parents that we've moved out of scope of
    while len(parents) && tag.line > parents[-1].end
      let parents = parents[:-2]
    endwhile

    " check if tag is a child
    if len(parents) && tag.line < parents[-1].end
      let parent = parents[-1]
      let parent_name = ''
      for parent in parents
        if parent_name != ''
          let parent_name .= '.'
        endif
        let parent_name .= parent.tag.name
      endfor
      let parent_name = a:types[parents[-1].tag.type] . ':' . parent_name
      let tag['parent'] = parent_name
    endif

    " check if tag is a potential parent
    if index(a:parent_types, tag.type) != -1
      call cursor(tag.line, 1)
      while search(a:parent_pair_start, 'W') && s:SkipComments()
        " no op
      endwhile
      let end = searchpair(
        \ a:parent_pair_start, '', a:parent_pair_end, 'W', 's:SkipComments()')
      call add(parents, {'tag': tag, 'start': tag.line, 'end': end})
    endif
  endfor

  call setpos('.', pos)
endfunction " }}}

function! s:SortTagsByLine(tag1, tag2) " {{{
  let line1 = a:tag1.line
  let line2 = a:tag2.line
  return line1 == line2 ? 0 : line1 > line2 ? 1 : -1
endfunction " }}}

function! s:SortTagsByName(tag1, tag2) dict " {{{
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

function! s:SkipComments() " {{{
  let synname = synIDattr(synID(line('.'), col('.'), 1), "name")
  return synname =~? '\(comment\|string\)'
endfunction " }}}

" vim:ft=vim:fdm=marker
