import asyncio
import nest_asyncio # needed because of some silly closed-minded people... https://bugs.python.org/issue22239#msg225883
nest_asyncio.apply()

loop = asyncio.new_event_loop()

class VimFlush():
  singleton = None
  resumable = None

  
  def __init__(self):
    self.fut = loop.create_future()
  
  async def wait(self):
    # vim.command('call UltiSnips#resume()')
    print('call aspync#resume()')
    self.resumable.fut.set_result(True)
    print('WAITING FOR VIM...')
    await self.fut
  
  def resume(self):
    self.fut.set_result(True)
    self.resumable.resume()
  
  @classmethod
  def init(cls):
    cls.singleton = cls()
  
VimResumed.init()

async def vim_resumed():
  await VimResumed.singleton.wait()

def resume():
  VimResumed.singleton.resume()
  

class EventLoop(object):
  """
  Event loop abstraction handle resumable function
  """
  def __init__(self, resumable:'Resumable'):
    self.resumable = resumable
  

class Resumable():
  current = None
  
  def __init__(self, fn, *args, **kwargs):
    self.fn = fn
    self.args = args
    self.kwargs = kwargs
    
    loop.create_task(self._exec_or_wait())
    self.resume()
  
  def resume(self):
      
    try:
      running_loop = asyncio.get_running_loop()
    except:
      running_loop = None
    if Resumeable.current is not None :
      running_loop.create_task
      
    
    asyncio.set_event_loop(loop)
    self.fut = loop.create_future()
    try:
      loop.run_until_complete(self._wait())
      #loop.create_task(self._wait())
      #loop.run_forever()
    finally:
      if running_loop is not None:
        asyncio.set_event_loop(running_loop)
    
  async def _wait(self):
    await self.fut
    
  async def _exec_or_wait(self):
    VimResumed.resumable = self
    await self.fn(*self.args, **self.kwargs)
    if not self.fut.done():
      self.fut.set_result(True)
    VimResumed.resumable = None




def wrap(fn):
  def main(*args, **kwargs):
    Resumeable(fn, *args, **kwargs)
  return main


@wrap
async def fn():
  print('WAITING')
  await vim_resumed()
  print('RESUMED')
  print('DONE')
  
print('START')
fn()
print('VIM DOES ITS STUFF')
resume()
print('ENDED')
