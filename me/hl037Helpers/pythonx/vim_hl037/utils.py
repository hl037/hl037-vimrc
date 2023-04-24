import io
import re

import vim

def getRange(start_marker, end_marker):
    buf = vim.current.buffer
    (lnum1, col1) = buf.mark(start_marker)
    (lnum2, col2) = buf.mark(end_marker)
    lines = list(buf[lnum1:lnum2])
    if len(lines) == 1:
        lines[0] = lines[0][col1:col2 + 1]
    else:
        lines[0] = lines[0][col1:]
        lines[-1] = lines[-1][:col2 + 1]
    return "\n".join(lines)
  
def setRange(start_marker, end_marker, text):
    buf = vim.current.buffer
    (lnum1, col1) = buf.mark(start_marker)
    (lnum2, col2) = buf.mark(end_marker)
    new_lines = text.split('\n')
    cur_start = buf[lnum1][:col1]
    cur_end = buf[lnum2][col2+1:]

    new_lines[0] = cur_start + new_lines[0]
    new_lines[1] = new_lines[-1] + cur_end
    buf[lnum1:lnum2] = new_lines
  
def getVisualRange():
  return getRange('<', '>')

def insert(txt):
  line, col = vim.current.window.cursor
  vim.current.line = vim.current.line[:col] + txt + vim.current.line[col:]

class CaseTranslator(object):
  @staticmethod
  def snake_case(words: list[str]):
    return '_'.join(words)
  
  snake = snake_case
  
  @staticmethod
  def Snake_Case(words: list[str]):
    return '_'.join( w.capitalize() for w in words )
  
  Snake = Snake_Case
  
  @staticmethod
  def SNAKE_CASE(words: list[str]):
    return '_'.join( w.upper() for w in words )
  
  SNAKE = SNAKE_CASE
  
  @staticmethod
  def CamelCase(words: list[str]):
    return ''.join( w.capitalize() for w in words )

  Camel = CamelCase
  
  @staticmethod
  def camelCase(words: list[str]):
    return ''.join(words[:1] + [ w.capitalize() for w in words[1:] ])

  camel = camelCase

class CaseTranslatorTokenizer(object):
  KIND_ID = 0
  KIND_SEP = 1
  KIND_SPACE = 2
  word_sep = re.compile(r'_|(?=[A-Z])')

  def __init__(self, s:str):
    self.s = s
    self.tok_start = 0
    self.tok_kind = None
    self.cur = 0

  def tokenize(self):
    for i in range(len(self.s)) :
      c = self.s[i]
      if c.isalpha() :
        if self.tok_kind is not self.KIND_ID :
          if self.tok_kind is not None :
            yield self.finalize(i, self.KIND_ID)
      elif c.isspace() :
        if self.tok_kind is not self.KIND_SPACE :
          if self.tok_kind is not None :
            yield self.finalize(i, self.KIND_SPACE)
      elif c == '_' :
        pass
      else :
        if self.tok_kind is not self.KIND_SEP :
          if self.tok_kind is not None :
            yield self.finalize(i, self.KIND_SEP)

  __iter__ = tokenize

  def finalize(self, i, next_kind):
    tok = self.s[self.tok_start:i]
    self.tok_start = i
    kind = self.tok_kind
    self.tok_kind = next_kind
    if self.tok_kind in (self.KIND_SEP, self.KIND_SPACE) :
      return tok, kind
    if tok.isupper() :
      return tok.split('_'), kind
    else :
      return self.word_sep.split(tok), kind

def convertCase(s, case_name):
  tr = getattr(CaseTranslator, case_name)
  buf = io.StringIO()
  for tok, kind in CaseTranslatorTokenizer(s) :
    if kind in (CaseTranslatorTokenizer.KIND_SEP, CaseTranslatorTokenizer.KIND_SEP) :
      buf.write(tok)
    else :
      buf.write(tr(tok))
  return buf.getvalue()

def switchCase(type, word_case):
  if type == '' :
    start_mark = "<"
    end_mark = ">"
  else :
    start_mark = "["
    end_mark = "]"
    
  setRange(start_mark, end_mark, convertCase(getRange(start_mark, end_mark), word_case))
  
