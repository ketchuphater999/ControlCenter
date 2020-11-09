local cobalt = dofile('ControlCenter/cobalt')
cobalt.ui = dofile('ControlCenter/cobalt-ui/init.lua')
cobalt.monitor = true

frame = {
    x = cobalt.window.getWidth(),
    y = cobalt.window.getHeight(),
}

--26x82

term.current().setTextScale(0.5)

local displayWidth = 79 --164 if 8-wide, 79 if 4-wide
local displayHeight = 52

scrollView = dofile('ControlCenter/ScrollView.lua')

local view = cobalt.ui.new({
    w = "100%",
    h = "100%",
    x = 1,
    y = 1,
    backColour = colours.white,
})

displayWidth = view.w
displayHeight = view.h

scrollView:setView(view)
scrollView:newContentView(50*2,colours.blue)

views = { }

for i = 0, math.floor(scrollView.contentView.h / 9) - 1, 1 do
    local new = scrollView.contentView:add("panel", {
        w = 50,
        h = 4,
        x = 5,
        y = (9 * i) + 3,
        backColour = 2 ^ math.random( 1, 15 )
    })
    table.insert(views,new)
end


function cobalt.draw()
    cobalt.ui.draw()
end  

function cobalt.update(dt)
    log("hi")
end

function cobalt.mousepressed( x, y, button )
    cobalt.ui.mousepressed( x, y, button )
    log("pressed")
end

function cobalt.mousereleased( x, y, button )
	cobalt.ui.mousereleased( x, y, button )
end

function log(s)
    f = fs.open('log', 'a')
    f.write(tostring(s)..'\n')
    f.flush()
    f.close()
end

cobalt.initLoop()