
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local tableGroup
local detailGroup,type,invitationType,name,userName,note,voteButton,voter
local backButton
local tableBackGround,detailBackGround
local inivitation_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/invitation")
local invitations = json.decode(inivitation_data)["invitations"]
local provision_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision")
local provisions = json.decode(provision_data)["provisions"]


-- widget event
local function setInvitationDetail(id)
    local data = http.request("http://smart-life-web.herokuapp.com/api/ver1/invitation/"..id)
    local invitation = json.decode(data)["invitation"]
    type.text = "ïÂèW"
    invitationType.text = invitation["type_name"]
    name.text = invitation["name"]
    userName.text = invitation["user_name"]
    note.text = invitation["note"]
    voters = invitation["voters"]
    for i=1,#voters do
        local voter = display.newText(detailGroup,voters[i]["name"],screenW/2,250+i*15)
        voter:setFillColor( 0, 0, 0 )
    end
end
local function setProvisionDetail(id)
    local data = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision/"..id)
    local provision = json.decode(data)["provision"]
    type.text = "íÒãü"
    invitationType.text = ""
    name.text = provision["name"]
    userName.text = provision["user_name"]
    note.text = provision["note"]
end
local function moveToDetail()
    tableGroup.isVisible=false
    detailGroup.isVisible=true
end
local function goDetail(model,id)
    if(model=="invitation") then
        setInvitationDetail(id)
    elseif(model=="provision") then
        setProvisionDetail(id)
    end
    moveToDetail()
end
local function onBackButton()
    composer.gotoScene( "map" )
end

-- set widget listener



-- scene event
function scene:create( event )
    local sceneGroup = self.view
    tableGroup = display.newGroup()
    detailGroup = display.newGroup()
    print("Map page create called")

    -- backGround
    tableBackGround = display.newImageRect( tableGroup,"imgs/background.jpg", display.contentWidth, display.contentHeight )
    tableBackGround.anchorX = 0
    tableBackGround.anchorY = 0

    -- invitations 2 row
    local invitation = display.newText( tableGroup,"invitations",60,30)
    invitation:setFillColor( 0, 0, 0 )

    local invitation_id1 = display.newText(tableGroup,invitations[1]["id"],50,50)
    invitation_id1:setFillColor( 0, 0, 0 )
    local invitation_name1 = display.newText(tableGroup,invitations[1]["name"],130,50)
    invitation_name1:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            goDetail("invitation",invitations[1]["id"])
        end
    end
    invitation_name1:addEventListener("touch",onRow)

    local invitation_id2 = display.newText(tableGroup,invitations[2]["id"],50,70)
    invitation_id2:setFillColor( 0, 0, 0 )
    local invitation_name2 = display.newText(tableGroup,invitations[2]["name"],130,70)
    invitation_name2:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            goDetail("invitation",invitations[2]["id"])
        end
    end
    invitation_name2:addEventListener("touch",onRow)

    -- provisions 2 row
    local provision = display.newText(tableGroup,"provisions",60,150)
    provision:setFillColor( 0, 0, 0 )

    local provision_id1 = display.newText(tableGroup,provisions[1]["id"],50,170)
    provision_id1:setFillColor( 0, 0, 0 )
    local provision_name1 = display.newText(tableGroup,provisions[1]["name"],130,170)
    provision_name1:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            goDetail("provision",provisions[1]["id"])
        end
    end
    provision_name1:addEventListener("touch",onRow)

    local provision_id2 = display.newText(tableGroup,provisions[2]["id"],50,190)
    provision_id2:setFillColor( 0, 0, 0 )
    local provision_name2 = display.newText(tableGroup,provisions[2]["name"],130,190)
    provision_name2:setFillColor( 0, 0, 0 )
    local function onRow(event)
        if(event.phase=="ended") then
            goDetail("provision",provisions[2]["id"])
        end
    end
    provision_name2:addEventListener("touch",onRow)

    -- backGround
    detailBackGround = display.newImageRect( detailGroup,"imgs/background.jpg", display.contentWidth, display.contentHeight )
    detailBackGround.anchorX = 0
    detailBackGround.anchorY = 0

    -- type
    type = display.newText(detailGroup,"type dummy",screenW/2,50)
    type:setFillColor( 0, 0, 0 )

    -- invitation type
    invitationType = display.newText(detailGroup,"invitation type dummy",screenW/2,70)
    invitationType:setFillColor( 0, 0, 0 )

    -- name
    name = display.newText(detailGroup,"name dummy", screenW/2,90)
    name:setFillColor( 0, 0, 0 )

    -- userName
    userName = display.newText(detailGroup,"user name dummy",screenW/2,110)
    userName:setFillColor( 0, 0, 0 )

    -- note
    note = display.newText(detailGroup,"note dummy",screenW/2,140)
    note:setFillColor( 0, 0, 0 )

    -- vote button
    voteButton = display.newImageRect(detailGroup, "imgs/bright_yellow_star.png",50,50)
    voteButton.x = screenW/2
    voteButton.y = 200

    -- voter
    voter = display.newText(detailGroup,"ìäï[àÍóó",screenW/2,240)
    voter:setFillColor( 0, 0, 0 )

    -- back button
    backButton = display.newImageRect(detailGroup,"imgs/back-button.png",50,50)
    backButton.x = 30
    backButton.y = 30
    backButton:addEventListener("touch",onBackButton)

    -- widget insert
    sceneGroup:insert( tableGroup )
    sceneGroup:insert( detailGroup )


end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        tableGroup.isVisible=true
        detailGroup.isVisible=false
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