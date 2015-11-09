
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local map,result
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

local function markerListener(event)
    local options =
    {
        body = "I scored over 9000!!! Can you do better?"
    }
    native.showPopup( "sms", options )end
-- scene event
function scene:create( event  )
    local sceneGroup = self.view

    -- map
    map = native.newMapView( 20, 20, screenW, screenH - 32 )
    map.x = display.contentCenterX
    map.y = display.contentCenterY - 32
    map.mapType = "standard"
    map:setRegion(34.7216618061847,137.739935164062,0.05,0.05,false)
    map.isLocationVisible=true


    -- widget insert
    sceneGroup:insert( map )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        map.isVisible = true

        -- invitations
        local invitations = getInvitations()
        local provisions = getProvisions()

        -- add marker
        local function addMarker( event )
            for i=1,#invitations do
                local options =
                {
                    title = invitations[i]["name"],
                    subtitle = "��W",
                    listener = markerListener(),
                }
                map:addMarker(invitations[i]["latitude"], invitations[i]["longitude"],options)
            end
            for i=1,#provisions do
                local options =
                {
                    title = provisions[i]["name"],
                    subtitle = "��",
                    listener = markerListener,
                }
                map:addMarker(provisions[i]["latitude"], provisions[i]["longitude"],options)
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
        map.isVisible = false
        map:removeAllMarkers()

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