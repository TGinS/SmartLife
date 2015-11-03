-----------------------------------------------------------------------------------------
--
-- map.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local backGround, text

-- widget event


-- set widget listener


-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    backGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0

    -- sample text
    text = display.newText("Map Tab",100,100)
    text.x,text.y = screenW/2,screenH/2
    text:setFillColor(0,0,0)

    print("---------")
    local data = http.request("https://smart-life-web.herokuapp.com/invitation/1.json")
    local invitation = json.decode(data)
    print(invitation["id"])
    print(invitation["name"])
    print(invitation["creator"])
    print(invitation["latitude"])
    print(invitation["longitude"])
    print(invitation["note"])
    print(invitation["contract"])
    print(invitation["end_date"])
    print(invitation["candidates"])

    --for key, val in pairs(decoded) do
     --   print(key, val)
    --end
    -- widget insert
    sceneGroup:insert( backGround )
    sceneGroup:insert( text )
end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end
end
function scene:destroy( event )
    local sceneGroup = self.view
    -- Called prior to the removal of scene's "view" (sceneGroup)
end

-- Add scene Listener
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene