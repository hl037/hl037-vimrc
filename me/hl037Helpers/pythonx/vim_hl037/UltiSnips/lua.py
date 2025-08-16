import re

sol_or_annotation_re = re.compile(r'\s*(?P<ann>---)?\s*')
def sol_or_annotation(snip, match):
  before = snip.before[:-len(match[0])]
  return sol_or_annotation_re.fullmatch(before)

def not_comment(snip):
  return '--' not in snip.before

def add_annotation(snip):
  if not snip.context['ann'] :
    snip.rv = '---'

class_re = re.compile(r'---@class\s+(?P<name>\w+)')
def get_class_name(snip):
  pos = snip.line
  while pos :
    line = snip.buffer[pos]
    if m := class_re.match(line) :
      return m['name']
    pos -= 1
  return ''


sanitize_re = re.compile('[^a-zA-Z0-9_]')
def sanitize_name(name):
  return sanitize_re.sub(name, '_')
