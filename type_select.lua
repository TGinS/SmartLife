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
local backGround,invitationButton,provisionButton,latText,lngText
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
    provisionButton.y = 200
    provisionButton:addEventListener("touch",gotoAddProvision)

    latText = display.newText(composer.getVariable("latitude"),screenW/2,300)
    latText:setFillColor( 0, 0, 0 )
    lngText = display.newText(composer.getVariable("longitude"),screenW/2,320)
    lngText:setFillColor( 0, 0, 0 )

    sceneGroup:insert(backGround)
    sceneGroup:insert(invitationButton)
    sceneGroup:insert(provisionButton)
    sceneGroup:insert(latText)
    sceneGroup:insert(lngText)

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

    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        print("Map page hide will called")

    elseif phase == "did" then
        print("Map page hide did called")
        sceneGroup:remove(invitationGroup)
        sceneGroup:remove(provisionGroup)
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

