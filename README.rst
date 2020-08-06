.. Copyright (c) 2005 - 2020, Eric Van Dewoestine
   All rights reserved.

   Redistribution and use of this software in source and binary forms, with
   or without modification, are permitted provided that the following
   conditions are met:

   * Redistributions of source code must retain the above
     copyright notice, this list of conditions and the
     following disclaimer.

   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the
     following disclaimer in the documentation and/or other
     materials provided with the distribution.

   * Neither the name of Eric Van Dewoestine nor the names of its
     contributors may be used to endorse or promote products derived from
     this software without specific prior written permission of
     Eric Van Dewoestine.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

TaglistToo is a vim plugin which provides an outline, or taglist, of a source
file in a separate window allowing you to quickly get an overview of the file
you are working on and to quickly jump to class definitions, methods,
functions, etc.

TaglistToo is very similar to the very popular taglist.vim_ written by Yegappan
Lakshmanan, but with a focus on being extensible and customizable. TaglistToo
provides hooks allowing you to format the taglist content per file type and to
also write code to parse file types not supported well or at all by ctags.

Please note that TaglistToo requires that vim be compiled with python3 support
and that you have `exuberant ctags`_ installed.

Please see the vim help file for full documentation.

.. _exuberant ctags: http://ctags.sourceforge.net/
.. _taglist.vim: http://www.vim.org/scripts/script.php?script_id=273
