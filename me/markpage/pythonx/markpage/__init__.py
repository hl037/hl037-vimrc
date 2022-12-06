import re

def default_distance(s1, s2):
  return 0 if s1 == s2 else 1

class Location(object):
  """
  A location
  """
  def __init__(self, file, line, text=None, buffer=None):
    self.file = file
    self.line = line
    self.text = text
    self.buffer = buffer

class Line(object):
  """
  Line abstraction to define what is at a line
  """
  KIND_EMPTY = 0
  KIND_BOOKMARK = 1
  KIND_CONTENT = 2
  KIND_COMMENT = 3
  kind = KIND_EMPTY
  def __init__(self):
    pass
    


class Markpage(object):
  """
  This class represents an instance of markpage
  """
  def __init__(self, buffer):
    try :
      import Levenshtein
    except :
      self.distance = default_distance
    else :
      self.distance = Levenshtein.distance
    self.buffer = buffer
    self.locations = []


  def parse(self, lines):
    

    

