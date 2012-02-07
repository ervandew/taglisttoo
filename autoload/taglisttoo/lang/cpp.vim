" Author:  Eric Van Dewoestine
"
" License: {{{
"   Copyright (c) 2011 - 2012, Eric Van Dewoestine
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
function! taglisttoo#lang#cpp#Parse(file, settings)
  let tags = taglisttoo#util#ParseCtags(a:file, a:settings)

  let types = {}
  for [t, n] in items(a:settings.tags)
    let types[n] = t
  endfor

  let parents = []
  let seen = []
  let index = 0
  for tag in tags
    if tag.parent != '' && index(seen, tag.parent) == -1
      call add(seen, tag.parent)
      let type_name = substitute(tag.parent, '^\(.\{-}\):.*', '\1', '')
      if !has_key(types, type_name)
        continue
      endif
      let type = types[type_name]
      let name = substitute(tag.parent, '^.\{-}:\(.*\)', '\1', '')
      let parts = split(name, '::')
      let name = parts[-1]

      let parent_name = ''
      let parent_filter = 'v:val.name == name'

      " single level nesting, so we can use the type to see if parent exists
      if len(parts) == 1
        let parent_filter .= ' && v:val.type == type'

      " multi level nesting, so rely we can't use the type
      else
        let parent_name = join(parts[:-2], '::')
        let parent_filter .= ' && v:val.parent =~ "^.\\{-}:" . parent_name . "$"'
      endif

      " check if the parent already exists
      let exists = filter(copy(tags), parent_filter)
      if len(exists) == 0
        let parent = {}
        let parent_path = ''
        " the parent we are injecting has a parent, so construct its parent
        " path
        if parent_name != ''
          let parent_list = filter(copy(tags), 'v:val.name == parent_name')
          if len(parent_list) == 1
            let parent = parent_list[0]
            let parent_parent = substitute(parent.parent, '^.\{-}:\(.*\)', '\1', '')
            if parent_parent != ''
              let parent_parent .= '::'
            endif
            let parent_type = a:settings.tags[parent.type]
            let parent_path = parent_type . ':' . parent_parent . parent.name
          endif
        endif

        " top level injected parent can be pushed to the front of the tag list
        if !len(parent)
          let insert_index = index
          let index += 1
          let parent_line = -1

        " nested injected parent must be inserted before its parent tag
        else
          let insert_index = len(parents) + index(tags, parent) + 1
          let parent_line = parent.line + 1
        endif

        call add(parents, [insert_index, {
            \ 'name': name,
            \ 'line': parent_line,
            \ 'type': type,
            \ 'type_name': type_name,
            \ 'pattern': '',
            \ 'parent': parent_path
          \ }])
      endif
    endif
  endfor

  for [idx, parent] in parents
    call insert(tags, parent, idx)
  endfor

  return tags
endfunction " }}}

" vim:ft=vim:fdm=marker
