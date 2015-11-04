
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local backGround, map
local inivitation_data = http.request("https://smart-life-web.herokuapp.com/invitation.json")
local invitations = json.decode(inivitation_data)
local provision_data = http.request("https://smart-life-web.herokuapp.com/provision.json")
local provisions = json.decode(provision_data)


-- widget event


-- set widget listener


-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    backGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0


    -- map
    map = native.newMapView( 20, 20, screenW, screenH - 32 )
    map.x = display.contentCenterX
    map.y = display.contentCenterY - 32
    map.mapType = "standard"
    map: setRegion(34.7216618061847,137.739935164062,0.05,0.05,false)
    map.isLocationVisible=true

    -- add marker
    local function addMarker( event )
        for i=1,#invitations do
            map:addMarker(invitations[i]["latitude"], invitations[i]["longitude"],{
                title = invitations[i]["name"],
                subtitle = "ïÂèW"})
        end
        for i=1,#provisions do
            map:addMarker(provisions[i]["latitude"], provisions[i]["longitude"],{
                title = provisions[i]["name"],
                subtitle = "íÒãü"})
        end
    end
    timer.performWithDelay( 10, addMarker )



    -- widget insert
    sceneGroup:insert( backGround )


end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        map.isVisible = true
    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        map.isVisible = false
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