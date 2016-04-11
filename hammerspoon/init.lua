-- Open Chrome conditionally
function hs.urlevent.httpCallback (_, _, _, fullUrl)
  -- TODO make this conditional on being on work machine
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
hs.application.watcher.new(function(_, event, app)
  if (event == hs.application.watcher.activated
      and app:bundleID() ~= "org.hammerspoon.Hammerspoon") then
    frontmost = app
  end
end):start()

-- Paste from the find pasteboard
hs.hotkey.bind({"cmd", "alt"}, "v", nil, function()
  local old = hs.pasteboard.getContents()
  pf()
  hs.eventtap.keyStroke({"cmd"}, "v")
  hs.timer.doAfter(0.1, function()
    hs.pasteboard.setContents(old)
  end)
end)

-- Puts the find pasteboard on the regular pasteboard
function pf()
  local find = hs.pasteboard.getContents("Apple CFPasteboard find")
  hs.pasteboard.setContents(find)
end
