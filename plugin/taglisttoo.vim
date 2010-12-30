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

if exists('g:taglisttoo_loaded') ||
   \ (exists('g:TaglistTooEnabled') && !g:TaglistTooEnabled) ||
   \ !has('python')
  finish
endif
let g:taglisttoo_loaded = 1

" try to disable taglist.vim
let g:loaded_taglist = 1

" Global Variables {{{

if !exists('g:Tlist_Ctags_Cmd')
  if executable('exuberant-ctags')
    let g:Tlist_Ctags_Cmd = 'exuberant-ctags'
  elseif executable('ctags')
    let g:Tlist_Ctags_Cmd = 'ctags'
  elseif executable('ctags.exe')
    let g:Tlist_Ctags_Cmd = 'ctags.exe'
  elseif executable('tags')
    let g:Tlist_Ctags_Cmd = 'tags'
  endif
endif

" no ctags found, no need to continue.
if !exists('g:Tlist_Ctags_Cmd')
  echohl WarningMsg | echom 'ctags not found' | echohl Normal
  finish
endif

if !exists('g:Tlist_Auto_Open')
  let g:Tlist_Auto_Open = 0
endif

if !exists("g:TaglistTooPosition")
  if exists('Tlist_Use_Right_Window') && Tlist_Use_Right_Window
    let g:TaglistTooPosition = 'right'
  else
    let g:TaglistTooPosition = 'left'
  endif
endif

if !exists('g:TagList_title')
  let g:TagList_title = "[TagList]"
endif

if !exists('g:Tlist_WinWidth')
  let g:Tlist_WinWidth = 30
endif

if !exists('g:Tlist_Sort_Type')
  let g:Tlist_Sort_Type = 'name'
endif

if !exists('g:TaglistTooTagEcho')
  let g:TaglistTooTagEcho = 1
endif

if g:Tlist_Auto_Open && !exists('g:Tlist_Temp_Disable')
  augroup taglisttoo_autoopen
    autocmd!
    autocmd VimEnter * nested call taglisttoo#taglist#AutoOpen()
  augroup END

  " Auto open on new tabs as well.
  if v:version >= 700
    autocmd taglisttoo_autoopen BufWinEnter *
      \ if tabpagenr() > 1 &&
      \     !exists('t:Tlist_Auto_Opened') &&
      \     !exists('g:SessionLoad') |
      \   call taglisttoo#taglist#AutoOpen() |
      \   let t:Tlist_Auto_Opened = 1 |
      \ endif
  endif
endif

augroup taglisttoo_file_session
  autocmd!
  autocmd SessionLoadPost * call taglisttoo#taglist#Restore()
augroup END

" }}}

" Command Declarations {{{
if !exists(":TlistToo")
  command TlistToo :call taglisttoo#taglist#Taglist()
endif
" }}}

" vim:ft=vim:fdm=marker
