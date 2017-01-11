--| Modes

-- TODO add timeouts

function submode(m, mods, key)
  local n = hs.hotkey.modal.new(nil, nil, nil)
  function n:exited()
    m:exit()
  end
  m:bind(mode, key, function () n:enter() end, nil, nil)
  return n
end

slash = hs.hotkey.modal.new({"cmd"}, "\\", nil)
p = submode(slash, nil, "p")
p:bind(nil, "f", function () pf() p:exit() end, nil, nil)
p:bind(nil, "s", function () ps() p:exit() end, nil, nil)

--| Open links from Slack in Chrome

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

