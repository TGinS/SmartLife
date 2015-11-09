
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local myMap,result
local backButton

-- widget event

local function getInvitations()
    local inivitation_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/invitation")
    local invitations = json.decode(inivitation_data)["invitations"]
    return invitations
end
local function getProvisions()
    local provision_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision")
    local provisions = json.decode(provision_data)["provisions"]
    return provisions
end

local function gotoTypeSelect()
    composer.setVariable("latitude",lat)
    composer.setVariable("longitude",lng)
    composer.gotoScene("type_select")
end
local function gotoInvitation(id)
    composer.setVariable("invitationId",id)
    composer.gotoScene("invitation")
end
local function gotoProvision(id)
    composer.setVariable("provisionId",id)
    composer.gotoScene("provision")
end

local function markerListeneDummyr(event)

end
local function markerListener(event)
    local options =
    {
        body = "I scored over 9000!!! Can you do better?"
    }
    native.showPopup( "sms", options )
end
-- scene event
function scene:create( event  )
    local sceneGroup = self.view

    -- Create a native map view
    myMap = native.newMapView( 0, 0, 300, 220 )
    myMap.x = display.contentCenterX
    myMap.y = display.contentCenterY


    -- widget insert
    sceneGroup:insert( myMap )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- invitations
        local invitations = getInvitations()
        local provisions = getProvisions()
        local function addMarker()
            for i=1,#invitations do
                local options =
                {
                    title = "Displayed Title",
                    subtitle = "Subtitle text",
                    listener = markerListener,
                    -- This will look in the resources directory for the image file
                    -- Alternatively, this looks in the specified directory for the image file
                    -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
                }
                myMap:addMarker(invitations[i]["latitude"], invitations[i]["longitude"],options)
            end
            for i=1,#provisions do
                local options =
                {
                    title = "Displayed Title",
                    subtitle = "Subtitle text",
                    listener = markerListener,
                    -- This will look in the resources directory for the image file
                    -- Alternatively, this looks in the specified directory for the image file
                    -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
                }
                myMap:addMarker(provisions[i]["latitude"], provisions[i]["longitude"],options)
            end
        end
        timer.performWithDelay( 10, addMarker )

        --gotoInvitation(invitations[i]["id"])

    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then

    elseif phase == "did" then

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