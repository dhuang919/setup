local retina_id = 69734272
local horizontal_id = 722499789
local vertical_id = 724851918

LAPTOP = hs.screen.find(retina_id)
HORIZONTAL = hs.screen.find(horizontal_id)
VERTICAL = hs.screen.find(vertical_id)

SCREENS = {
  LAPTOP = LAPTOP,
  HORIZONTAL = HORIZONTAL,
  VERTICAL = VERTICAL,
}

local screens = {}
screens.SCREENS = SCREENS

function screens.placeWindow(window, screen, ratios)
  screen = screens.SCREENS[screen]
  window:moveToScreen(SCREENS[screen])
  if ratios.full_screen then
    window:setFullScreen(true)
  else
    screen_height = screen:frame().h
    screen_width = screen:frame().w

    top = screen_height * ratios.top
    left = screen_width * ratios.left
    height = screen_height * ratios.height
    width = screen_width * ratios.width

    window:setTopLeft(screen:localToAbsolute(hs.geometry.point(left, top)))
    window:setSize(hs.geometry.size(width, height))
  end
end

return screens
