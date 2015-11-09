
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

local function gotoTypeSelect(lat,lng)
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

-- scene event
function scene:create( event  )
    local sceneGroup = self.view

    -- Create a native map view
    myMap = native.newMapView( 20, 20, screenW, screenH - 32 )
    myMap.x = display.contentCenterX
    myMap.y = display.contentCenterY - 32
    myMap.mapType = "standard"
    myMap:setRegion(34.7216618061847,137.739935164062,0.05,0.05,false)
    myMap.isLocationVisible=false

    local function mapTapListener( event )
        gotoTypeSelect( event.latitude, event.longitude)
    end
    myMap:addEventListener( "mapLocation", mapTapListener )

    -- widget insert
    sceneGroup:insert( myMap )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        myMap.isVisible = true
        -- invitations
        local invitations = getInvitations()
        local provisions = getProvisions()
        local function addMarker()
            for i=1,#invitations do
                local function callInvitation()
                    gotoInvitation(invitations[i]["id"])
                end
                local options =
                {
                    title = invitations[i]["name"],
                    subtitle = "ïÂèW",
                    listener = callInvitation,
                    -- This will look in the resources directory for the image file
                    -- Alternatively, this looks in the specified directory for the image file
                    -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
                }
                myMap:addMarker(invitations[i]["latitude"], invitations[i]["longitude"],options)
            end
            for i=1,#provisions do
                local function callProvision()
                    gotoInvitation(invitations[i]["id"])
                end
                local options =
                {
                    title = provisions[i]["name"],
                    subtitle = "íÒãü",
                    listener = callProvision,
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
        myMap.isVisible = false
        myMap:removeAllMarkers()
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