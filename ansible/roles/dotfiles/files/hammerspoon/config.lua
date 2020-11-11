HAMMERSPOON_DIR = os.getenv('HOME') .. '/.hammerspoon/'

function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

myWatcher = hs.pathwatcher.new(HAMMERSPOON_DIR, reloadConfig):start()
hs.alert.show('Config reloaded')

local c = {}
c.HAMMERSPOON_DIR = HAMMERSPOON_DIR
return c
