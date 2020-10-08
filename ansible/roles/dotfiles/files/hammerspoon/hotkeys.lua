local c = require("config")
local o = require("open")


hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'W', function()
  o.openAndMove("Mail", "LAPTOP", 0.05, 0.02, 0.77, 0.8)
  o.openAndMove("Slack", "LAPTOP", 0.063, 0.2, 0.9, 0.77)
  o.openAndMove("Spotify", "LAPTOP", 0.233, 0.01, 0.77, 0.7)
  o.openAndMove("Calendar", "LAPTOP", 0.31, 0.287, 0.68, 0.67)

  o.openAndMove("Google Chrome", "VERTICAL", 0.2088, 0, 0.359, 1)
  o.openAndMove("iTerm", "VERTICAL", 0.568, 0, 0.44, 1)

  o.openAndMove("Typora", "HORIZONTAL", 0.16, 0.428, 0.718, 0.462)
end)
