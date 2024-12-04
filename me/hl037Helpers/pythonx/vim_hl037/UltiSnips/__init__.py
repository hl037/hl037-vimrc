class Nil:
	pass

def eol(snip):
  return snip.column == len(snip.buffer[snip.line]) - 1

def recompute(*plc):
  cache = {}
  def decorator(f):
    def wrapper(snip, t, *args, **kwargs):
      key = tuple(t[p] for p in plc)
      res = cache.get(key, Nil)
      if res is Nil:
        res = f(snip, t, *args, **kwargs)
        cache[key] = res
      return res
    return wrapper
  return decorator

