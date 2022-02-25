local o = require('open')

local ratios = {
  chrome = {
    full_screen = false,
    top = 0.19,
    left = 0,
    height = 0.378,
    width = 1,
  },
  iterm = {
    full_screen = false,
    top = 0.568,
    left = 0,
    height = 0.44,
    width = 1,
  },
  mail = {
    full_screen = false,
    top = 0.05,
    left = 0.004,
    height = 0.77,
    width = 0.8,
  },
  slack = {
    full_screen = false,
    top = 0.063,
    left = 0.02,
    height = 0.875,
    width = 0.95,
  },
  spotify = {
    full_screen = false,
    top = 0.24,
    left = 0.01,
    height = 0.77,
    width = 0.7,
  },
  obsidian = {
    full_screen = false,
    top = 0.16,
    left = 0.428,
    height = 0.55,
    width = 0.4,
  },
}

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'W', function()
  o.moveIfOpen('Mail', 'LAPTOP', ratios.mail)
  o.moveIfOpen('Slack', 'LAPTOP', ratios.slack)
  o.moveIfOpen('Spotify', 'LAPTOP', ratios.spotify)

  o.moveIfOpen('Insomnia', 'HORIZONTAL', ratios.insomnia)
  o.moveIfOpen('Obsidian', 'HORIZONTAL', ratios.obsidian)

  o.moveIfOpen('iTerm2', 'VERTICAL', ratios.iterm)
  o.moveIfOpen('Google Chrome', 'VERTICAL', ratios.chrome)
end)

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'R', function()
  hs.reload()
  hs.notify.new({title='Hammerspoon', informativeText='Config reloaded'}):send()
end)
