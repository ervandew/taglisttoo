"""
Copyright (c) 2005 - 2011, Eric Van Dewoestine
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
"""
import os
import re
import subprocess
import tempfile
import vim

def ctags(lang, types, filename):
  ctags = vim.eval('g:Tlist_Ctags_Cmd')

  startupinfo = None
  if os.name == 'nt':
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW

  stdoutfile = tempfile.TemporaryFile()
  stderrfile = tempfile.TemporaryFile()
  try:
    process = subprocess.Popen(
        [
          ctags,
          '-f', '-',
          '--format=2',
          '--excmd=pattern',
          '--fields=nks',
          '--sort=no',
          '--language-force=%s' % lang,
          '--%s-types=%s' % (lang, types),
          filename,
        ],
        stdout=stdoutfile,
        stderr=stderrfile,
        stdin=subprocess.PIPE,
        startupinfo=startupinfo,
    )

    retcode = process.wait()
    if retcode != 0:
      stderrfile.seek(0)
      return (retcode, stderrfile.read())

    stdoutfile.seek(0)
    return (retcode, stdoutfile.read())

  finally:
    stdoutfile.close()
    stderrfile.close()

def jsctags(filename):
  jsctags = vim.eval('g:Tlist_JSctags_Cmd')

  startupinfo = None
  if os.name == 'nt':
    startupinfo = subprocess.STARTUPINFO()
    startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW

  temp = tempfile.mkstemp()[1]
  try:
    process = subprocess.Popen(
        [
          jsctags,
          '-o', temp,
          filename,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        startupinfo=startupinfo,
    )

    retcode = process.wait()
    if retcode != 0:
      return (retcode, process.communicate()[1].strip())
    return (retcode, open(temp).read())
  finally:
    os.unlink(temp)

def parse(filename, patterns):
  f = open(filename, 'r')
  contents = f.read()
  f.close()

  for i, info in enumerate(patterns):
    flags = re.DOTALL | re.MULTILINE
    if len(info) > 3:
      if info[3] == 'i':
        flags |= re.IGNORECASE
      info = info[:3]
      patterns[i] = info

    try:
      info[1] = re.compile(info[1], flags)
    except:
      print 'Failed to parse pattern: %s' % info[1]
      raise

  offsets = FileOffsets.compile(filename)

  results = []
  for ptype, regex, group in patterns:
    for match in regex.finditer(contents):
      start = match.start()
      end = match.end()
      line = offsets.offsetToLineColumn(start)[0]
      col = 1

      if group.isdigit():
        name = match.group(int(group))
      else:
        matched = contents[start:end]
        name = regex.sub(group, matched)

      first = offsets.getLineStart(line)
      last = offsets.getLineEnd(offsets.offsetToLineColumn(end)[0])
      pattern = contents[first:last]

      # pattern cannot span lines
      if '\n' in pattern:
        lines = pattern.split('\n')
        for i, l in enumerate(lines):
          if name in l:
            pattern = l
            line += i
            col = l.index(name) + 1
            break

        # still multiline, so just use the first one
        if '\n' in pattern:
          pattern = lines[0]
      elif name in pattern:
        col = pattern.index(name) + 1

      # escape slashes
      pattern = pattern.replace('\\', '\\\\')
      # remove ctrl-Ms
      pattern = pattern.replace('\r', '')

      results.append({
        'type': ptype,
        'name': name,
        'pattern': '^%s$' % pattern,
        'line': line,
        'column': col,
      })

  return results

class FileOffsets(object):
  def __init__(self):
    self.offsets = []

  @staticmethod
  def compile(filename):
    offsets = FileOffsets()
    offsets.compileOffsets(filename)
    return offsets;

  def compileOffsets(self, filename):
    f = file(filename, 'r')
    try:
      self.offsets.append(0);

      offset = 0;
      for line in f:
        offset += len(line)
        self.offsets.append(offset)
    finally:
      f.close()

  def offsetToLineColumn(self, offset):
    if offset <= 0:
      return [1, 1]

    bot = -1
    top = len(self.offsets) - 1
    while (top - bot) > 1:
      mid = (top + bot) / 2
      if self.offsets[mid] < offset:
        bot = mid
      else:
        top = mid

    if self.offsets[top] > offset:
      top -= 1

    line = top + 1
    column = 1 + offset - self.offsets[top]
    return [line, column]

  def getLineStart(self, line):
    return self.offsets[line - 1]

  def getLineEnd(self, line):
    if len(self.offsets) == line:
      return self.offsets[len(self.offsets) - 1]

    return self.offsets[line] - 1;
