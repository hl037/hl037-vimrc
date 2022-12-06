
class Palette(object):
  """
  A color palette.
  Vim is used in CLI, not every terminal running it has
  true colors support. This palet is an abstraction to 
  vim's hilight support.
  """
  def __init__(self):
    pass

class AbstractCanvas(object):
  """
  This class defines the interface of a canvas
  """
  def __init__(self):
    pass

  def setPalette(self, palet:Palette):
    pass

  async def flush():
    pass
    


