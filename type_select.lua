--
-- Created by IntelliJ IDEA.
-- User: Taiga
-- Date: 2015/11/09
-- Time: 20:10
-- To change this template use File | Settings | File Templates.
--
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local backGround,invitationButton,provisionButton,locationText,map
local backButton

-- widget event
local function gotoAddInvitation()
    composer.gotoScene("add_invitation")
end
local function gotoAddProvision()
    composer.gotoScene("add_provision")
end
local function gotoMap()
    composer.gotoScene( "map_tab" )
end

-- scene event
function scene:create( event  )
    local sceneGroup = self.view

    backGround = display.newImageRect("imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0

    -- buttons
    invitationButton = display.newImageRect("imgs/invitationButton.png", 100,50 )
    invitationButton.x = screenW/2
    invitationButton.y = 100
    invitationButton:addEventListener("touch",gotoAddInvitation)

    provisionButton = display.newImageRect("imgs/provisionButton.png", 100,50 )
    provisionButton.x = screenW/2
    provisionButton.y = 180
    provisionButton:addEventListener("touch",gotoAddProvision)

    -- text
    locationText = display.newText("’Ç‰ÁˆÊ’u",screenW/2,220)
    locationText:setFillColor( 0, 0, 0 )

    --map
    map = native.newMapView( 20, 20, screenW-150, 150 )
    map.x = screenW/2
    map.y = 310
    map:setRegion(34.7216618061847,137.739935164062,0.05,0.05,false)
    map.mapType = "standard"
    map.isLocationVisible=false


    sceneGroup:insert(backGround)
    sceneGroup:insert(invitationButton)
    sceneGroup:insert(provisionButton)
    sceneGroup:insert(locationText)
    sceneGroup:insert(map)

    -- back button
    backButton = display.newImageRect("imgs/back-button.png",50,50)
    backButton.x = 30
    backButton.y = 30
    local function onBackButton()
        gotoMap()
    end
    backButton:addEventListener("touch",onBackButton)

    sceneGroup:insert( backButton )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        map.isVisible = true
        local lat = composer.getVariable("latitude")
        local lng = composer.getVariable("longitude")
        local options =
        {
            title = "Title",
            subtitle = "Type",
            -- This will look in the resources directory for the image file
            -- Alternatively, this looks in the specified directory for the image file
            -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
        }
        map:addMarker(lat, lng,options)
        map:setCenter(lat, lng)
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        map:removeAllMarkers()
        map.isVisible = false

    elseif phase == "did" then
        print("Map page hide did called")

    end
end
function scene:destroy( event )
    local sceneGroup = self.view
    print("Map page destroy called")
end

-- Add scene Listener
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

