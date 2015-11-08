
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local dummyMapBackGround,invitationText,invitationId1,invitationName1,invitationId2,invitationName2,provisionText,provisionId1,provisionName1,provisionId2,provisionName2
local invitationBackGround,invitationTitle,invitationType,invitationName,invitationUserName,invitationNote,invitationVoteButton,invitationVoterText,invitationVoterGroup
local provisionBackGround,provisionTitle,provisionName,provisionUserName,provisionNote
local backButton
local inivitation_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/invitation")
local invitations = json.decode(inivitation_data)["invitations"]
local provision_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision")
local provisions = json.decode(provision_data)["provisions"]


-- widget event
local function reviveDummyMap()
    dummyMapBackGround.isVisible    = true
    invitationText.isVisible        = true
    invitationId1.isVisible         = true
    invitationName1.isVisible       = true
    invitationId1.isVisible         = true
    invitationName2.isVisible       = true
    provisionId1.isVisible          = true
    provisionName1.isVisible        = true
    provisionId2.isVisible          = true
    provisionName2.isVisible        = true
end
local function reviveInvitationDetail()
    invitationBackGround.isVisible =    true
    invitationTitle.isVisible =         true
    invitationType.isVisible =          true
    invitationName.isVisible =          true
    invitationUserName.isVisible =      true
    invitationNote.isVisible =          true
    invitationVoteButton.isVisible =    true
    invitationVoterText.isVisible =     true
    invitationVoterGroup.isVisible =     true
    backButton.isVisible =              true
end
local function reviveProvisionDetail()
    provisionBackGround.isVisible = true
    provisionTitle.isVisible =      true
    provisionName.isVisible =       true
    provisionUserName.isVisible =   true
    provisionNote.isVisible =       true
    backButton.isVisible =          true
end
local function killDummymap()
    dummyMapBackGround.isVisible    = false
    invitationText.isVisible        = false
    invitationId1.isVisible         = false
    invitationName1.isVisible       = false
    invitationId1.isVisible         = false
    invitationName2.isVisible       = false
    provisionId1.isVisible          = false
    provisionName1.isVisible        = false
    provisionId2.isVisible          = false
    provisionName2.isVisible        = false
end
local function killInvitationDetail()
    invitationBackGround.isVisible =    false
    invitationTitle.isVisible =         false
    invitationType.isVisible =          false
    invitationName.isVisible =          false
    invitationUserName.isVisible =      false
    invitationNote.isVisible =          false
    invitationVoteButton.isVisible =    false
    invitationVoterText.isVisible =     false
    invitationVoterGroup.isVisible =     false
    backButton.isVisible =              false
end
local function killProvisionDetail()
    provisionBackGround.isVisible = false
    provisionTitle.isVisible =      false
    provisionName.isVisible =       false
    provisionUserName.isVisible =   false
    provisionNote.isVisible =       false
    backButton.isVisible =          false
end
local function setInvitationDetail(id)
    local data = http.request("http://smart-life-web.herokuapp.com/api/ver1/invitation/"..id)
    local invitation = json.decode(data)["invitation"]
    invitationTitle.text    = "��W"
    invitationType.text     = invitation["type_name"]
    invitationName.text     = invitation["name"]
    invitationUserName.text = invitation["user_name"]
    invitationNote.text     = invitation["note"]
    local voters = invitation["voters"]
    for i=1,#voters do
        local invitationVoter = display.newText(invitationVoterGroup,voters[i]["name"],screenW/2,250+i*15)
        invitationVoter:setFillColor( 0, 0, 0 )
    end
end
local function setProvisionDetail(id)
    local data              = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision/"..id)
    local provision         = json.decode(data)["provision"]
    provisionTitle.text     = "��"
    provisionName.text      = provision["name"]
    provisionUserName.text  = provision["user_name"]
    provisionNote.text      = provision["note"]
end
local function displayMapDummy()
    killInvitationDetail()
    killProvisionDetail()
    reviveDummyMap()
end
local function displayInvitationDetail(id)
    killDummymap()
    killProvisionDetail()
    setInvitationDetail(id)
    reviveInvitationDetail()
end
local function displayProvisionDetail(id)
    killDummymap()
    killInvitationDetail()
    setProvisionDetail(id)
    reviveProvisionDetail()
end
local function backToMap()
    composer.gotoScene( "map" )
end

-- set widget listener



-- scene event
function scene:create( event )
    local sceneGroup = self.view

    print("Map page create called")

    -- backGround
    dummyMapBackGround = display.newImageRect("imgs/background.jpg", display.contentWidth, display.contentHeight )
    dummyMapBackGround.anchorX = 0
    dummyMapBackGround.anchorY = 0

    -- invitations 2 row
    invitationText = display.newText("invitations",60,30)
    invitationText:setFillColor( 0, 0, 0 )

    invitationId1 = display.newText(invitations[1]["id"],50,50)
    invitationId1:setFillColor( 0, 0, 0 )
    invitationName1 = display.newText(invitations[1]["name"],130,50)
    invitationName1:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            displayInvitationDetail(invitations[1]["id"])
        end
    end
    invitationName1:addEventListener("touch",onRow)

    invitationId2 = display.newText(invitations[2]["id"],50,70)
    invitationId2:setFillColor( 0, 0, 0 )
    invitationName2 = display.newText(invitations[2]["name"],130,70)
    invitationName2:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            displayInvitationDetail(invitations[2]["id"])
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
            displayProvisionDetail(provisions[1]["id"])
        end
    end
    provisionName1:addEventListener("touch",onRow)

    provisionId2 = display.newText(provisions[2]["id"],50,190)
    provisionId2:setFillColor( 0, 0, 0 )
    provisionName2 = display.newText(provisions[2]["name"],130,190)
    provisionName2:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            displayProvisionDetail(provisions[2]["id"])
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

    -- backGround
    invitationBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    invitationBackGround.anchorX = 0
    invitationBackGround.anchorY = 0

    -- invitation title
    invitationTitle = display.newText("type dummy",screenW/2,50)
    invitationTitle:setFillColor( 0, 0, 0 )

    -- name
    invitationName = display.newText("name dummy", screenW/2,90)
    invitationName:setFillColor( 0, 0, 0 )

    -- invitation type
    invitationType = display.newText("invitation type dummy",screenW/2,70)
    invitationType:setFillColor( 0, 0, 0 )

    -- userName
    invitationUserName = display.newText("user name dummy",screenW/2,110)
    invitationUserName:setFillColor( 0, 0, 0 )

    -- note
    invitationNote = display.newText("note dummy",screenW/2,140)
    invitationNote:setFillColor( 0, 0, 0 )

    -- vote button
    invitationVoteButton = display.newImageRect( "imgs/bright_yellow_star.png",50,50)
    invitationVoteButton.x = screenW/2
    invitationVoteButton.y = 200

    -- voter
    invitationVoterText = display.newText("���[�ꗗ",screenW/2,240)
    invitationVoterText:setFillColor( 0, 0, 0 )

    invitationVoterGroup = display.newGroup()

    -- widget insert
    sceneGroup:insert( invitationBackGround )
    sceneGroup:insert( invitationTitle )
    sceneGroup:insert( invitationName )
    sceneGroup:insert( invitationUserName )
    sceneGroup:insert( invitationNote )
    sceneGroup:insert( invitationVoteButton )
    sceneGroup:insert( invitationVoterText )
    sceneGroup:insert( invitationVoterGroup )


    provisionBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    provisionBackGround.anchorX = 0
    provisionBackGround.anchorY = 0

    provisionTitle = display.newText("provision type dummy",screenW/2,50)
    provisionTitle:setFillColor( 0, 0, 0 )

    -- name
    provisionName = display.newText("provision name dummy", screenW/2,90)
    provisionName:setFillColor( 0, 0, 0 )

    -- usr name
    provisionUserName = display.newText("provision user name dummy", screenW/2,120)
    provisionUserName:setFillColor( 0, 0, 0 )

    -- usr name
    provisionNote = display.newText("provision note dummy", screenW/2,140)
    provisionNote:setFillColor( 0, 0, 0 )

    sceneGroup:insert( provisionBackGround )
    sceneGroup:insert( provisionTitle )
    sceneGroup:insert( provisionName )
    sceneGroup:insert( provisionUserName )
    sceneGroup:insert( provisionNote )

    -- back button
    backButton = display.newImageRect("imgs/back-button.png",50,50)
    backButton.x = 30
    backButton.y = 30
    backButton:addEventListener("touch",backToMap)

    sceneGroup:insert( backButton )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        print("Map page show will called")
        displayMapDummy()
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