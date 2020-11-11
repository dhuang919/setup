local c = require('config')
local o = require('open')


hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'W', function()
  o.moveIfOpen('Slack', 'LAPTOP', 0.063, 0.02, 0.9, 0.95)
  o.moveIfOpen('Spotify', 'LAPTOP', 0.233, 0.01, 0.77, 0.7)
  o.moveIfOpen('Calendar', 'LAPTOP', 0.31, 0.287, 0.68, 0.67)

  o.moveIfOpen('Google Chrome', 'VERTICAL', 0.19, 0, 0.378, 1)
  o.moveIfOpen('iTerm2', 'VERTICAL', 0.568, 0, 0.44, 1)

  o.moveIfOpen('Typora', 'HORIZONTAL', 0.16, 0.428, 0.718, 0.462)
end)
