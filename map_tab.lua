
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local dummyMapBackGround,invitationText,invitationGroup,provisionText,provisionGroup,addButton
local flash
local backButton
local lat,lng = 35.681085187825936,139.25330186328122

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

-- scene event
function scene:create( event  )
    local sceneGroup = self.view

    -- backGround
    dummyMapBackGround = display.newImageRect("imgs/background.jpg", display.contentWidth, display.contentHeight )
    dummyMapBackGround.anchorX = 0
    dummyMapBackGround.anchorY = 0

    invitationText = display.newText("土地活用方法応募",100,30)
    invitationText:setFillColor( 0, 0, 0 )

    provisionText = display.newText("土地提供",60,0)
    provisionText:setFillColor( 0, 0, 0 )

    addButton = display.newImageRect("imgs/FAB.png",50,50)
    addButton.x = screenW-50
    addButton.y = screenH-100
    local function onAddButton(event)
        gotoTypeSelect()
    end
    addButton:addEventListener("touch",onAddButton)


    -- widget insert
    sceneGroup:insert( dummyMapBackGround )
    sceneGroup:insert( invitationText )
    sceneGroup:insert( provisionText )
    sceneGroup:insert( addButton )

    -- flash text
    flash = display.newText("",screenW-50,screenH-100)
    flash:setFillColor( 0, 0, 0 )

    sceneGroup:insert( flash )
end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then

        -- invitations
        local invitations = getInvitations()
        invitationGroup = display.newGroup()
        for i=1,#invitations do
            local invitationId = display.newText(invitationGroup,invitations[i]["id"],50,50+i*25)
            invitationId:setFillColor( 0, 0, 0 )
            local invitationName = display.newText(invitationGroup,invitations[i]["name"],130,50+i*25)
            invitationName:setFillColor( 0, 0, 0 )
            local function onInvitationName(event)
                if(event.phase=="ended") then
                    gotoInvitation(invitations[i]["id"])
                end
            end
            invitationName:addEventListener("touch",onInvitationName)
        end
        sceneGroup:insert(invitationGroup)

        -- provisions
        provisionText.y = 80+ #invitations * 25
        local provisions = getProvisions()
        provisionGroup = display.newGroup()
        for i=1,#provisions do
            local provisionId = display.newText(provisionGroup,provisions[i]["id"],50,80+i*25+#invitations*25)
            provisionId:setFillColor( 0, 0, 0 )
            local provisionName = display.newText(provisionGroup,provisions[i]["name"],130,80+i*25+#invitations*25)
            provisionName:setFillColor( 0, 0, 0 )
            local function onProvisionName(event)
                if(event.phase=="ended") then
                    gotoProvision(provisions[i]["id"])
                end
            end
            provisionName:addEventListener("touch",onProvisionName)
        end
        sceneGroup:insert(provisionGroup)

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