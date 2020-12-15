local screens = require('screens')

function getApp(app)
  focused = hs.application.get(app)
  if app == 'Code' and not focused then
    -- special logic for vscode — https://github.com/Hammerspoon/hammerspoon/issues/2075
    focused = hs.application.get('Visual Studio Code')
  end
  return focused
end

function moveIfOpen(app, screen, ratios)
  focused = getApp(app)
  if not focused then return false end
  activate_success = focused:activate()
  if not activate_success then return false end
  window = focused:focusedWindow()
  if not window then return false end
  screens.placeWindow(window, screen, ratios)
  return true
end

function openFullScreen(app, screen)
  focused = open(app)
  if not focused then return false end
  window = hs.window.focusedWindow()
  window:moveToScreen(screens.SCREENS[screen])
  window:setFullScreen(true)
  return true
end

local o = {}
o.moveIfOpen = moveIfOpen
o.openFullScreen = openFullScreen
return o
