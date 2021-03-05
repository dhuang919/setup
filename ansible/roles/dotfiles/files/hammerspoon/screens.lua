LAPTOP = hs.screen.find('Built-in Retina Display')
HORIZONTAL = hs.screen.find('DELL U2518D')
VERTICAL = hs.screen.find('DELL U2515H')

SCREENS = {
  LAPTOP = LAPTOP,
  HORIZONTAL = HORIZONTAL,
  VERTICAL = VERTICAL,
}

local screens = {}
screens.SCREENS = SCREENS
-- for k, v in ipairs(hs.screen.allScreens()) do
--   print(v)
-- end
function screens.placeWindow(window, screen, ratios)
  local screenObj = screens.SCREENS[screen]
  -- print(screen)
  -- print(screenObj)
  window:moveToScreen(SCREENS[screen])
  if ratios.full_screen then
    window:setFullScreen(true)
  else
    screen_height = screenObj:frame().h
    screen_width = screenObj:frame().w

    top = screen_height * ratios.top
    left = screen_width * ratios.left
    height = screen_height * ratios.height
    width = screen_width * ratios.width

    window:setTopLeft(screenObj:localToAbsolute(hs.geometry.point(left, top)))
    window:setSize(hs.geometry.size(width, height))
  end
end

return screens
