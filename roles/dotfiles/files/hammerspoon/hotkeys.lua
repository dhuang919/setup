local o = require('open')

local ratios = {
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
    left = 0.29,
    height = 0.78,
    width = 0.69,
  },
  calendar = {
    top = 0.1,
    left = 0.53,
    height = 0.5,
    width = 0.42,
  }
}

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'W', function()
  o.moveIfOpen('Slack', 'LAPTOP', ratios.slack)
  o.moveIfOpen('Spotify', 'LAPTOP', ratios.spotify)

  o.moveIfOpen('Obsidian', 'LAPTOP', ratios.obsidian)

  o.moveIfOpen('iTerm2', 'VERTICAL', ratios.iterm)
  o.moveIfOpen('Google Chrome', 'VERTICAL', ratios.chrome)

  o.moveIfOpen('Calendar', 'HORIZONTAL', ratios.calendar)
end)

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'R', function()
  hs.reload()
  hs.notify.new({title='Hammerspoon', informativeText='Config reloaded'}):send()
end)
