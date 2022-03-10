SCREENS = {}

for k, v in ipairs(hs.screen.allScreens()) do
  if string.find(v:name(), 'Retina') then
    SCREENS.LAPTOP = v
  end
  if string.find(v:name(), 'U2518D') then
    SCREENS.HORIZONTAL = v
  end
  if string.find(v:name(), 'U2515H') then
    SCREENS.VERTICAL = v
  end
end

local screens = {}
screens.SCREENS = SCREENS

function screens.placeWindow(window, screen, ratios)
  local screenObj = screens.SCREENS[screen]
  if screenObj == nil then
    return
  end
  window:moveToScreen(SCREENS[screen])
  screen_height = screenObj:frame().h
  screen_width = screenObj:frame().w

  top = screen_height * ratios.top
  left = screen_width * ratios.left
  height = screen_height * ratios.height
  width = screen_width * ratios.width

  window:setTopLeft(screenObj:localToAbsolute(hs.geometry.point(left, top)))
  window:setSize(hs.geometry.size(width, height))
end

return screens
