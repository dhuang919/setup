local screens = require("screens")

function open(app)
  focused = hs.application.launchOrFocus(app)
  if app == "Code" and not focused then
    -- special logic for vscode — https://github.com/Hammerspoon/hammerspoon/issues/2075
    focused = hs.application.launchOrFocus("Visual Studio Code")
  end
  return focused
end

function openAndMove(app, screen, t_ratio, l_ratio, h_ratio, w_ratio)
  print("app", app)
  focused = open(app)
  if not focused then return false end
  window = hs.window.focusedWindow()
  screens.placeWindow(window, screen, t_ratio, l_ratio, h_ratio, w_ratio)
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
o.open = open
o.openAndMove = openAndMove
o.openFullScreen = openFullScreen
return o
