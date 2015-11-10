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
local invitationBackGround,invitationTitle,invitationType,invitationName,invitationUserName,invitationNote,invitationVoteButton,invitationVoterText,invitationVoterGroup
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
    invitationTitle = display.newText("活用方法応募",screenW/2,100,nil,25)
    invitationTitle:setFillColor( 0, 0, 0 )

    -- name
    invitationName = display.newText("name", screenW/2,130,nil,25)
    invitationName:setFillColor( 0, 0, 0 )

    -- invitation type
    invitationType = display.newText("type_name",screenW/2,160,nil,25)
    invitationType:setFillColor( 0, 0, 0 )

    -- userName
    invitationUserName = display.newText("user_name",screenW/2,190,nil,25)
    invitationUserName:setFillColor( 0, 0, 0 )

    -- note
    invitationNote = display.newText("note",screenW/2,220,nil,25)
    invitationNote:setFillColor( 0, 0, 0 )

    -- vote button
    invitationVoteButton = display.newImageRect( "imgs/bright_yellow_star.png",100,100)
    invitationVoteButton.x = screenW/2
    invitationVoteButton.y = 300


    -- voter
    invitationVoterText = display.newText("投票者",screenW/2,370,nil,25)
    invitationVoterText:setFillColor( 0, 0, 0 )



    -- widget insert
    sceneGroup:insert( invitationBackGround )
    sceneGroup:insert( invitationTitle )
    sceneGroup:insert( invitationName )
    sceneGroup:insert( invitationType )
    sceneGroup:insert( invitationUserName )
    sceneGroup:insert( invitationNote )
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
            local invitationVoter = display.newText(invitationVoterGroup,voters[i]["name"],screenW/2,250+i*15)
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