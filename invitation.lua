-----------------------------------------------------------------------------------------
--
-- invitation.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local invitationBackGround,invitationTitle,invitationType,invitationName,invitationUserName,invitationNote,map,invitationVoteButton,invitationVoterText,invitationVoterGroup
local flash
local backButton

-- widget event
local function getInvitation(invitationId)
    local data = http.request("http://smart-life-web.herokuapp.com/api/ver1/invitation/"..invitationId)
    local invitation = json.decode(data)["invitation"]
    return invitation
end
local function voteInvitation(invitationId)
    -- http request
    local reqbody = "invitation_id="..invitationId
    respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/invitation_vote",
        method = "POST",
        headers =
        {
            ["Accept"] = "*/*",
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Uid"] = userInfo["uId"],
            ["Access-token"] = userInfo["accessToken"],
            ["content-length"] = string.len(reqbody)
        },
        source = ltn12.source.string(reqbody),
        sink = ltn12.sink.table(respbody)
    }
    flash.text = "Vote!"
    flash.isVisible = true
end
local function gotoMap()
    composer.gotoScene( "map_tab" )
end

-- scene event
function scene:create( event )
    local sceneGroup = self.view


    -- backGround
    invitationBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    invitationBackGround.anchorX = 0
    invitationBackGround.anchorY = 0

    -- invitation title
    invitationTitle = display.newText("Invitation",screenW/2,50)
    invitationTitle:setFillColor( 0, 0, 0 )

    -- name
    invitationName = display.newText("name", screenW/2,90)
    invitationName:setFillColor( 0, 0, 0 )

    -- invitation type
    invitationType = display.newText("type_name",screenW/2,70)
    invitationType:setFillColor( 0, 0, 0 )

    -- userName
    invitationUserName = display.newText("user_name",screenW/2,110)
    invitationUserName:setFillColor( 0, 0, 0 )

    -- note
    invitationNote = display.newText("note",screenW/2,140)
    invitationNote:setFillColor( 0, 0, 0 )

    --map
    map = native.newMapView( 20, 20, screenW-100, 100 )
    map.x = screenW/2
    map.y = 200
    map:setRegion(34.7216618061847,137.739935164062,0.05,0.05,false)
    map.mapType = "standard"
    map.isLocationVisible=false

    -- vote button
    invitationVoteButton = display.newImageRect( "imgs/bright_yellow_star.png",25,25)
    invitationVoteButton.x = screenW-screenW/5
    invitationVoteButton.y = screenH-70


    -- voter
    invitationVoterText = display.newText("ÊäïÁ•®ËÄ?",screenW/2,270)
    invitationVoterText:setFillColor( 0, 0, 0 )



    -- widget insert
    sceneGroup:insert( invitationBackGround )
    sceneGroup:insert( invitationTitle )
    sceneGroup:insert( invitationName )
    sceneGroup:insert( invitationType )
    sceneGroup:insert( invitationUserName )
    sceneGroup:insert( invitationNote )
    sceneGroup:insert( map )
    sceneGroup:insert( invitationVoteButton )
    sceneGroup:insert( invitationVoterText )


    -- back button
    backButton = display.newImageRect("imgs/back-button.png",50,50)
    backButton.x = 30
    backButton.y = 30
    local function onBackButton()
        gotoMap()
    end
    backButton:addEventListener("touch",onBackButton)
    -- flash text
    flash = display.newText("",screenW-50,screenH-100)
    flash:setFillColor( 0, 0, 0 )


    sceneGroup:insert( backButton )
    sceneGroup:insert( flash )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then

        local invitationId = composer.getVariable("invitationId")
        local invitation = getInvitation(invitationId)
        invitationName.text = invitation["name"]
        invitationType.text = invitation["type_name"]
        invitationUserName.text = invitation["user_name"]
        invitationNote.text = invitation["note"]

        --map
        map.isVisible = true
        local options =
        {
            title = invitation["name"],
            subtitle = "ïÂèW",
            -- This will look in the resources directory for the image file
            -- Alternatively, this looks in the specified directory for the image file
            -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
        }
        map:addMarker(invitation["latitude"], invitation["longitude"],options)
        map:setCenter(invitation["latitude"], invitation["longitude"])


        -- vote button
        local function onInvitationVote(event)
            if(event.phase == "ended") then
                voteInvitation(invitationId)
            end
        end
        invitationVoteButton:addEventListener("touch", onInvitationVote)
        if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
            invitationVoteButton.isVisible = false
        else
            invitationVoteButton.isVisible = true
        end

        -- voter
        local voters = invitation["voters"]
        invitationVoterGroup = display.newGroup()
        for i=1,#voters do
            local invitationVoter = display.newText(invitationVoterGroup,voters[i]["name"],screenW/2,270+i*15)
            invitationVoter:setFillColor( 0, 0, 0 )
        end
        sceneGroup:insert( invitationVoterGroup )


    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        map:removeAllMarkers()
        map.isVisible = false
    elseif phase == "did" then
        sceneGroup:remove( invitationVoterGroup )
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