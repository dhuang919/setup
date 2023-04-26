local o = require('open')

local ratios = {
  bbvpn = {
    top = 0.57,
    left = 0.01,
    height = 0.4,
    width = 0.25,
  },
  calendar = {
    top = 0.07,
    left = 0.33,
    height = 0.6,
    width = 0.62,
  },
  chrome = {
    top = 0.19,
    left = 0,
    height = 0.378,
    width = 1,
  },
  iterm = {
    top = 0.568,
    left = 0,
    height = 0.44,
    width = 1,
  },
  mail = {
    top = 0.03,
    left = 0.004,
    height = 0.77,
    width = 0.8,
  },
  slack = {
    top = 0.063,
    left = 0.02,
    height = 0.7,
    width = 0.7,
  },
  spotify = {
    top = 0.24,
    left = 0.01,
    height = 0.77,
    width = 0.7,
  },
  obsidian = {
    top = 0.21,
    left = 0.28,
    height = 0.78,
    width = 0.69,
  },
}

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'W', function()
  o.moveIfOpen('Slack', 'LAPTOP', ratios.slack)
  o.moveIfOpen('Spotify', 'LAPTOP', ratios.spotify)
  o.moveIfOpen('bbvpn2', 'LAPTOP', ratios.bbvpn)
  o.moveIfOpen('Calendar', 'LAPTOP', ratios.calendar)
  o.moveIfOpen('Obsidian', 'LAPTOP', ratios.obsidian)

  o.moveIfOpen('iTerm2', 'VERTICAL', ratios.iterm)
  o.moveIfOpen('Google Chrome', 'VERTICAL', ratios.chrome)
end)

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'R', function()
  hs.reload()
  hs.notify.new({title='Hammerspoon', informativeText='Config reloaded'}):send()
end)
