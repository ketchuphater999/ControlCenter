ScrollView = {
    scrollView = { },
    contentView = { },
    navBar = { },
    contentContainer = { },
}

local view = { }
local thumb = { }
local thumbArea = { }
local viewableRatio = 1.0
local contentHeight = 0
local navHeight = 4
local scrollWidth = 6
local buttonHeight = 4
local screenHeight = 52
local screenWidth = 164
local scrollInc = 8

function ScrollView:setView(newView)
    view = newView
    contentHeight = screenHeight - navHeight
    screenHeight = view.h
    screenWidth = view.w
    
    ScrollView.scrollView = view:add("panel",{
        w = scrollWidth,
        h = screenHeight - navHeight,
        y = navHeight + 1,
        x = screenWidth - scrollWidth + 1,
        backColour = colours.grey
    })
    
    ScrollView.navBar = view:add("panel", {
        w = "100%",
        h = 4,
        x = 1,
        y = 1,
        backColour = colours.orange,
        alwaysfocus = true
    })    
    
    thumbArea = ScrollView.scrollView:add("panel", {
        w = scrollWidth,
        h = ScrollView.scrollView.h - (buttonHeight * 2),
        x = 1,
        y = buttonHeight + 1,
        backColour = colours.grey,
    })
    
    thumb = thumbArea:add("panel", {
        w = scrollWidth,
        h = ScrollView.scrollView.h - (buttonHeight * 2),
        x = 1,
        y = 1,
        backColour = colours.pink,
    })
    
    local upButton = ScrollView.scrollView:add("button", {
        w = scrollWidth,
        h = buttonHeight,
        x = 1,
        y = 1,
        text = "^",
        backColour = colours.lightGrey
    })
    upButton.onclick = scrollUp
    
    
    local downButton = ScrollView.scrollView:add("button", {
        w = scrollWidth,
        h = buttonHeight,
        x = 1,
        y = ScrollView.scrollView.h - buttonHeight + 1,
        text = "v",
        backColour = colours.lightGrey,
    })
    downButton.onclick = scrollDown
    
end

function ScrollView:newContentView(height, color)
    ScrollView.contentContainer = view:add("panel", {
        w = screenWidth - scrollWidth,
        h = screenHeight - navHeight,
        x = 1,
        y = navHeight + 1
    })
    
    ScrollView.contentView = ScrollView.contentContainer:add("panel", {
        w = screenWidth - scrollWidth,
        h = height,
        x = 1,
        y = 1,
        backColour = color
    })
    viewableRatio = (screenHeight - navHeight) / height
    updateScrollBar()
end

function updateScrollBar()
    thumbHeight = viewableRatio * (screenHeight - navHeight - 4.0)
    thumb:resize(ScrollView.scrollView.w, thumbHeight)
    
    position = -1 * (ScrollView.contentView.y - 1) / ScrollView.contentView.h
    
    local pos = position * thumbArea.h + 1
    thumb.y = math.floor(pos)
    
    log(pos)
end

function scrollUp()
    local pos = ScrollView.contentView.y
    pos = pos + scrollInc
    if pos > 1 then
        pos = 1
    end
    ScrollView.contentView.y = pos
    updateScrollBar()
end

function scrollDown()
    local pos = ScrollView.contentView.y
    pos = pos - scrollInc
    if pos < -1 * ((ScrollView.contentView.h - ScrollView.contentContainer.h) - 1) then
        pos = -1 * ((ScrollView.contentView.h - ScrollView.contentContainer.h) - 1)
    end
    ScrollView.contentView.y = pos
    updateScrollBar()
end

function copy2(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[copy2(k)] = copy2(v) end
    return res
end

function log(s)
    f = fs.open('log', 'a')
    f.write(tostring(s)..'\n')
    f.flush()
    f.close()
end

return ScrollView