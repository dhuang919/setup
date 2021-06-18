local o = require('open')

local ratios = {
  calendar = {
    full_screen = false,
    top = 0.31,
    left = 0.287,
    height = 0.68,
    width = 0.67,
  },
  chrome = {
    full_screen = false,
    top = 0.19,
    left = 0,
    height = 0.378,
    width = 1,
  },
  insomnia = {
    full_screen = false,
    top = 0.308,
    left = 0.312,
    height = 0.58,
    width = 0.56,
  },
  iterm = {
    full_screen = false,
    top = 0.568,
    left = 0,
    height = 0.44,
    width = 1,
  },
  outlook = {
    full_screen = false,
    top = 0.1,
    left = 0.132,
    height = 0.65,
    width = 0.57,
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
  typora = {
    full_screen = false,
    top = 0.16,
    left = 0.428,
    height = 0.55,
    width = 0.4,
  },
}

hs.hotkey.bind({'alt', 'cmd', 'ctrl'}, 'W', function()
  -- o.moveIfOpen('Calendar', 'LAPTOP', ratios.calendar)
  o.moveIfOpen('Slack', 'LAPTOP', ratios.slack)
  o.moveIfOpen('Spotify', 'LAPTOP', ratios.spotify)

  o.moveIfOpen('Insomnia', 'HORIZONTAL', ratios.insomnia)
  o.moveIfOpen('Microsoft Outlook', 'HORIZONTAL', ratios.outlook)
  o.moveIfOpen('Typora', 'HORIZONTAL', ratios.typora)

  o.moveIfOpen('iTerm2', 'VERTICAL', ratios.iterm)
  o.moveIfOpen('Google Chrome', 'VERTICAL', ratios.chrome)
end)
