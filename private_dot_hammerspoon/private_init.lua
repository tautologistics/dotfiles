local hyper = {"ctrl", "alt"}
hs.window.animationDuration = 0.05

-- hs.loadSpoon('Amphetamine')
hs.loadSpoon('ControlEscape'):start()
hs.loadSpoon('Anycomplete'):bind(hyper, 'a')
hs.loadSpoon('MiroWindowsManager')

spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "z"}
})


-- hs.urlevent.bind("someAlert", function(eventName, params)
--   hs.alert.show("Received someAlert")
-- end)
