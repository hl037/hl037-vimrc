import re

def blockStart(snip, pos=None) -> tuple[str, int]:
  """
  Return the first line of the block and its index
  """
  if pos is None :
    pos = snip.line
  line = snip.buffer[pos]
  i = next(( i for i, a in enumerate(line) if a not in ' \t' ), len(line)) # first non blank char
  indent = line[:i]
  return next(( (l, pos - i) for i in range(pos) if (l := snip.buffer[pos - i]).strip() and not l.startswith(indent) ), (None, 0)) # type: str
  

def maybeMatchCase(snip):
  candidate, _ = blockStart(snip)
  if candidate is None :
    return False
  return candidate.lstrip().startswith('match')

def_re = re.compile(r'\s*def\s*(?P<name>[\w\D]\w*)\((?P<params>.*)\)\s*:(?:\s*#.*)?')
def inFunction(snip):
  l, i = blockStart(snip)
  while l is not None :
    m = def_re.fullmatch(l)
    if m :
      return (m['name'], m['params'])
    if l.lstrip().startswith('class'):
      return False
    l, i = blockStart(snip, i)
  return False

def _testComment(s, start):
  return next(( (t[-3:], ind) for t in ('"""', "'''", 'r"""', "r'''") if (ind := s.index(t, start)) != -1 ), (None, start))

def inHeader(snip):
  incomment = None
  indent_chars = ' \t'
  for i in range(snip.line) :
    l = snip.buffer[i] # type: str
    ls = l.rstrip()
    comind = 0
    if incomment is None :
      if l[0] not in indent_chars and not any(ls.startswith(w) for w in ('#', 'from', 'import')) :
        incomment, comind = _testComment(l, comind)
        if comind is None or comind > (len(l) - len(ls)) :
          return False
    while incomment is not None and (comind := l.index(incomment, comind)) != -1 :
      comind += 3
      incomment, comind = _testComment(l, comind)
      if comind == -1 :
        break
  return True

def not_comment(snip):
  return '#' not in snip.before


# from dataclasses import dataclass
# 
# class ExpressionParser(object):
#   """
#   Parser capable of handling parenthesis and square brackets...
# 
#   The automaton builds a Tree.
#   """
#   LT = 0
#   DL = 1
#   BG = 2
#   EG = 3
#   IG = -1
# 
#   List = 0
#   Group = 1
#   Call = 2
# 
#   @dataclass
#   class List(object):
#     """
#     List with a separator
#     """
#     dl:str
#     d:list['ExpressionParser.Tree']
# 
#   @dataclass
#   class Group(object):
#     """
#     Group (inside group delimiter)
#     """
#     bg:str
#     eg:str
#     d:'ExpressionParser.Tree'
# 
#   @dataclass
#   class Call(object):
#     """
#     Call (group with a name before)
#     """
#     name:str
#     bg:str
#     eg:str
#     d:'ExpressionParser.Tree'
# 
#   Tree = str | tuple[str, 'Tree'] | tuple[str, list['Tree']]
#   Stack = list[Tree]
# 
#   list_delimiters = [] # type: list[tuple[str, int]]
#   group_delimiters = [] # type: list[tuple[str, str]]
#   ignored = [] # type: list[str]
# 
#   def get_token(self, s:str):
#     if rv := next(( ig for ig in self.ignored if s.startswith(ig) ), None) :
#       return self.IG, rv
#     elif rv := next(( eg for _, eg in self.group_delimiters if s.startswith(eg) ), None) :
#       return self.EG, rv
#     elif rv := next(( (bg, eg) for bg, eg in self.group_delimiters if s.startswith(bg) ), None) :
#       return self.BG, rv
#     elif rv := next(( (dl, p) for dl, p in self.list_delimiters if s.startswith(dl) ), None) :
#       return self.DL, rv
#     else :
#       return self.LT, s[0]
# 
#   def end_group(self, eg):
#     if len(self.L[-1]) :
#       self.end_list(self.L[-1][0])
#       s_ = self.S.pop()
#     else :
#       s_ = self.m
#       if s_ is None :
#         s_ = self.S.pop()
#     s__ = self.S[-1]
#     if eg != s__[2] :
#       raise NotMatchingEndGroup(f'Group begins with `{s__[1]}` and should end with `{s__[2]}` but `{eg}` found')
#     self.S[-1].d = s_
#     self.L.pop()
#     self.m = None
#     return
# 
#   def end_list(self, tok):
#     #breakpoint()
#     t, p = tok
#     if self.m is not None :
#       s_ = self.m
#     else :
#       s_ = self.S.pop()
#     self.m = ""
#     if self.L[-1] :
#       ct, cp = self.L[-1][-1]
#       while cp <= p :
#         self.S[-1].d.append(s_)
#         if cp == p and ct == t:
#           return
#         s_ = self.S.pop()
#         self.L[-1].pop()
#         if not self.L[-1] :
#           break
#         ct, cp = self.L[-1][-1]
#     self.S.append(self.List(t, [s_]))
#     self.L[-1].append(tok)
# 
#   def parse(self, s):
#     List = self.List
#     Group = self.Group
#     Call = self.Call
#     
#     self.S = []
#     self.L = [[]]
#     self.m = ""
#     i = 0
#     len_s = len(s)
#     # ic(s)
#     print('')
#     while i < len_s :
#       T, tok = self.get_token(s[i:])
#       # if T != self.LT :
#       #   ic(i, s[i:])
#       #   ic(self.S)
#       #   ic(self.L)
#       #   ic(self.m)
#       #   print('')
#       match T:
#         case self.LT:
#           if self.m is None :
#             raise LetterAfterGroup(f'{tok} occured just after a call or a group')
#           self.m += tok
#         case self.BG:
#           if self.m == "" :
#             self.S.append(Group(*tok, None))
#           else :
#             self.S.append(Call(self.m, *tok, None))
#             self.m = ""
#           tok = tok[0]
#           self.L.append([])
#         case self.EG:
#           self.end_group(tok)
#         case self.DL:
#           self.end_list(tok)
#           tok = tok[0]
#         case self.IG:
#           pass
#       i += len(tok)
#     if len(self.L) > 1 :
#       raise NotMatchingEndGroup('End of line found before encontering group end')
#     if len(self.S) == 0:
#       return self.m
#     if len(self.L[0]) >= 1 :
#       self.end_list(self.L[0][0])
#     return self.S[0]
      
      

