--| Modes

log = hs.logger.new('myconfig', 'debug')

currentMode = nil
modeTimeoutSeconds = 2
modeTimeout = hs.timer.new(0, function (timer)
  log.d("modeTimeout fired")
  if currentMode then
    currentMode:exit()
  end
end)
function setCurrentMode(newMode)
  currentMode = newMode
  if currentMode then
    modeTimeout:setNextTrigger(modeTimeoutSeconds)
  else
    modeTimeout:stop()
  end
end

function submode(m, mods, key)
  local n = hs.hotkey.modal.new(nil, nil, nil)
  function n:entered()
    setCurrentMode(n)
    log.df("will cancel submode %s %s in %f seconds", hs.inspect(mods), key, modeTimeoutSeconds)
  end
  function n:exited()
    -- exiting parent mode could be made an optional behavior in the future
    setCurrentMode(m)
    m:exit()
  end
  m:bind(mode, key, function () n:enter() end, nil, nil)
  return n
end

slash = hs.hotkey.modal.new({"cmd"}, "\\", nil)
function slash:entered()
  log.df("will cancel cmd-slash mode in %f seconds", modeTimeoutSeconds)
  setCurrentMode(slash)
end
function slash:exited()
  setCurrentMode(nil)
end
p = submode(slash, nil, "p")
p:bind(nil, "f", function () pf() p:exit() end, nil, nil)
p:bind(nil, "s", function () ps() p:exit() end, nil, nil)
k = submode(slash, nil, "k")
k:bind(nil, "e", function () ke() k:exit() end, nil, nil)
kj = submode(k, nil, "j")
kj:bind(nil, ";", function () kjsemi() kj:exit() end, nil, nil)
kj:bind(nil, "j", function () kjj() kj:exit() end, nil, nil)
kj:bind(nil, "k", function () kjk() kj:exit() end, nil, nil)
kj:bind(nil, "l", function () kjl() kj:exit() end, nil, nil)

--| Open links from Slack in Chrome
-- Note: I haven't used this in years

-- Open Chrome conditionally
function hs.urlevent.httpCallback (_, _, _, fullUrl)
  local isSlack = frontmost and frontmost:bundleID() == "com.tinyspeck.slackmacgap" 
  local cmdDown = hs.eventtap.checkKeyboardModifiers()["cmd"] 
  if cmdDown or isSlack then
    hs.urlevent.openURLWithBundle(fullUrl, "com.google.Chrome")
  else
    hs.urlevent.openURLWithBundle(fullUrl, "com.apple.Safari") 
  end
end

-- Track the frontmost app that is NOT Hammerspoon
-- (Sometimes Slack will be de-activated before httpCallback above runs)
frontmost = nil
w = hs.application.watcher.new(function(_, event, app)
  if (event == hs.application.watcher.activated
      and app:bundleID() ~= "org.hammerspoon.Hammerspoon") then
    frontmost = app
  end
end)
w:start()

--| Pasting

-- Swap the find pasteboard and the regular pasteboard
function ps()
  local pb = hs.pasteboard.getContents()
  local find = hs.pasteboard.getContents("Apple CFPasteboard find")
  hs.pasteboard.setContents(find)
  hs.pasteboard.setContents(pb, "Apple CFPasteboard find")
end

-- Paste from the find pasteboard
function pf()
  ps()
  hs.eventtap.keyStroke({"cmd"}, "v")
  hs.timer.doAfter(0.1, function()
      ps()
  end)
end

--| Keyboard

-- Switch to English keyboard layout
function ke()
  hs.keycodes.setLayout("U.S.")
end

-- Switch to Japanese input methods
function kjsemi()
  hs.keycodes.setMethod("Romaji")
end
function kjj()
  hs.keycodes.setMethod("Hiragana")
end
function kjk()
  hs.keycodes.setMethod("Katakana")
end
function kjl()
  hs.keycodes.setMethod("Full-width Romaji")
end