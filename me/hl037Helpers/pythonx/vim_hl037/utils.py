import io
import re

import vim

def getMark(buf, mark):
  (l, c) = buf.mark(mark)
  return l-1, c-1

def getRange(start_marker, end_marker):
    buf = vim.current.buffer
    (lnum1, col1) = getMark(buf, start_marker)
    (lnum2, col2) = getMark(buf, end_marker)

    lines = list(buf[lnum1:lnum2+1])
    if len(lines) == 1:
        lines[0] = lines[0][col1:col2 + 2]
    else:
        lines[0] = lines[0][col1:]
        lines[-1] = lines[-1][:col2 + 2]
    return "\n".join(lines)
  
def setRange(start_marker, end_marker, text):
    buf = vim.current.buffer
    (lnum1, col1) = getMark(buf, start_marker)
    (lnum2, col2) = getMark(buf, end_marker)
    new_lines = text.split('\n')
    cur_start = buf[lnum1][:col1]
    cur_end = buf[lnum2][col2+2:]

    new_lines[0] = cur_start + new_lines[0]
    new_lines[-1] = new_lines[-1] + cur_end
    buf[lnum1:lnum2 + 1] = new_lines
  
def getVisualRange():
  return getRange('<', '>')

def insert(txt):
  line, col = vim.current.window.cursor
  vim.current.line = vim.current.line[:col] + txt + vim.current.line[col:]
  
KIND_ID = 0
KIND_KEEP = 1
KIND_WORD = 2
KIND_UPPER = 3

class CaseTranslator(object):
  @staticmethod
  def snake_case(words: list[tuple[str, int]]):
    return '_'.join( w.lower() for w, k in words )
  
  snake = snake_case
  
  @staticmethod
  def Snake_Case(words: list[tuple[str, int]]):
    return '_'.join(
      w.capitalize() if k != KIND_UPPER else w.upper()
      for w, k in words
    )
  
  Snake = Snake_Case
  
  @staticmethod
  def SNAKE_CASE(words: list[tuple[str, int]]):
    return '_'.join( w.upper() for w, k in words )
  
  SNAKE = SNAKE_CASE
  
  @staticmethod
  def CamelCase(words: list[tuple[str, int]]):
    return ''.join(
      w.capitalize() if k != KIND_UPPER else w.upper()
      for w, k in words
    )

  Camel = CamelCase
  
  @staticmethod
  def camelCase(words: list[tuple[str, int]]):
    w, k = words[0]
    return ''.join(
      [w.lower() if k != KIND_UPPER else w.upper()]
      + [
        w.capitalize() if k != KIND_UPPER else w.upper()
        for w, k in words[1:]
      ]
    )

  camel = camelCase

class CaseTranslatorTokenizer(object):
  upper_cases = [
    'UART',
    'USB',
    'HTTP',
    'IP',
    'URL',
    'OS',
    'HTTPS',
    'FTP',
    'SSH',
    'WS'
  ]
  lower_cases = [ w.lower() for w in upper_cases ]
  upper_case_reg = re.compile('|'.join(upper_cases + [r'[1-9]+']))
  lower_case_reg = re.compile('|'.join(lower_cases + [r'[1-9]+']))
  keep_reg = re.compile(r'(__+|[^A-Za-z_1-9])+')
  general_sep_reg = re.compile(r'_|(?=[A-Z])')

  def __init__(self, s:str):
    self.s = s

  def _tokenize(self, s:str, reg:re.Pattern, then, tag_match, tag_unmatch):
    i = 0
    m = reg.search(s, i)
    if m is None :
      if tag_unmatch is None :
        yield from then(s)
      else :
        yield list(then(s)), tag_unmatch
      return
    while m :
      start, end = m.span()
      if start != i :
        if tag_unmatch is None :
          yield from then(s[i:start])
        else :
          yield list(then(s[i:start])), tag_unmatch
      yield m[0], tag_match
      if end >= len(s) :
        break
      i = end
      m = reg.search(s, i)
    else :
      if tag_unmatch is None :
        yield from then(s[end:])
      else :
        yield list(then(s[end:])), tag_unmatch

  def tokenize(self):
    yield from self._tokenize(self.s, self.keep_reg, self.finalizeId, KIND_KEEP, KIND_ID)

  __iter__ = tokenize

  def finalizeId(self, s:str):
    if any(c.isupper() for c in s) :
      yield from self._tokenize(s, self.upper_case_reg, self.finalizeWord, KIND_UPPER, None)
    else :
      yield from self._tokenize(s, self.lower_case_reg, self.finalizeWord, KIND_UPPER, None)
      

  def finalizeWord(self, s:str):
    if any(c.islower() for c in s) :
      return ( (w.lower(), KIND_WORD) for w in self.general_sep_reg.split(s) if w)
    else :
      return ( (w.lower(), KIND_WORD) for w in s.split('_') )
    
def convertCase(s, case_name):
  tr = getattr(CaseTranslator, case_name)
  return ''.join( tok if k == KIND_KEEP else tr(tok) for tok, k in CaseTranslatorTokenizer(s) )

def switchCase(type, word_case):
  if type == '' :
    start_mark = "<"
    end_mark = ">"
  else :
    start_mark = "["
    end_mark = "]"
    
  setRange(start_mark, end_mark, convertCase(getRange(start_mark, end_mark), word_case))
  
