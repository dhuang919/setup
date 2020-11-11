LAPTOP = hs.screen.find('Color LCD')
HORIZONTAL = hs.screen.find('DELL U2518D')
VERTICAL = hs.screen.find('DELL U2515H')

SCREENS = {
  LAPTOP = LAPTOP,
  HORIZONTAL = HORIZONTAL,
  VERTICAL = VERTICAL,
}

local screens = {}
screens.SCREENS = SCREENS

function screens.placeWindow(window, screen, t_ratio, l_ratio, h_ratio, w_ratio)
  screen = screens.SCREENS[screen]
  screen_height = screen:frame().h
  screen_width = screen:frame().w

  top = screen_height * t_ratio
  left = screen_width * l_ratio
  height = screen_height * h_ratio
  width = screen_width * w_ratio

  window:setFullScreen(false)
  window:moveToScreen(SCREENS[screen])
  window:setTopLeft(screen:localToAbsolute(hs.geometry.point(left, top)))
  window:setSize(hs.geometry.size(width, height))
end

return screens
