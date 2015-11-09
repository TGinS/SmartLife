
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local invitationId,provisionId,applicantId
local dummyMapBackGround,invitationText,invitationId1,invitationName1,invitationId2,invitationName2,provisionText,provisionId1,provisionName1,provisionId2,provisionName2



local flash
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

    print("Map page create called")

    -- backGround
    dummyMapBackGround = display.newImageRect("imgs/background.jpg", display.contentWidth, display.contentHeight )
    dummyMapBackGround.anchorX = 0
    dummyMapBackGround.anchorY = 0

    local invitations = getInvitations()
    local provisions = getProvisions()

    -- invitations 2 row
    invitationText = display.newText("invitations",60,30)
    invitationText:setFillColor( 0, 0, 0 )

    invitationId1 = display.newText(invitations[1]["id"],50,50)
    invitationId1:setFillColor( 0, 0, 0 )
    invitationName1 = display.newText(invitations[1]["name"],130,50)
    invitationName1:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            gotoInvitation(invitations[1]["id"])
        end
    end
    invitationName1:addEventListener("touch",onRow)

    invitationId2 = display.newText(invitations[2]["id"],50,70)
    invitationId2:setFillColor( 0, 0, 0 )
    invitationName2 = display.newText(invitations[2]["name"],130,70)
    invitationName2:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            gotoInvitation(invitations[2]["id"])
        end
    end
    invitationName2:addEventListener("touch",onRow)

    -- provisions 2 row
    provisionText = display.newText("provisions",60,150)
    provisionText:setFillColor( 0, 0, 0 )

    provisionId1 = display.newText(provisions[1]["id"],50,170)
    provisionId1:setFillColor( 0, 0, 0 )
    provisionName1 = display.newText(provisions[1]["name"],130,170)
    provisionName1:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            gotoProvision(provisions[1]["id"])
        end
    end
    provisionName1:addEventListener("touch",onRow)

    provisionId2 = display.newText(provisions[2]["id"],50,190)
    provisionId2:setFillColor( 0, 0, 0 )
    provisionName2 = display.newText(provisions[2]["name"],130,190)
    provisionName2:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            gotoProvision(provisions[2]["id"])
        end
    end
    provisionName2:addEventListener("touch",onRow)

    -- widget insert
    sceneGroup:insert( dummyMapBackGround )
    sceneGroup:insert( invitationText )
    sceneGroup:insert( invitationId1 )
    sceneGroup:insert( invitationName1 )
    sceneGroup:insert( invitationId2 )
    sceneGroup:insert( invitationName2 )
    sceneGroup:insert( provisionText )
    sceneGroup:insert( provisionId1 )
    sceneGroup:insert( provisionName1 )
    sceneGroup:insert( provisionId2 )
    sceneGroup:insert( provisionName2 )

    -- flash text
    flash = display.newText("",screenW-50,screenH-100)
    flash:setFillColor( 0, 0, 0 )

    sceneGroup:insert( flash )


end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        print("Map page show will called")
    elseif phase == "did" then
        print("Map page show did called")

    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        print("Map page hide will called")

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