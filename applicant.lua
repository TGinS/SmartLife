-----------------------------------------------------------------------------------------
--
-- applicant.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local applicantBackGround,applicantTitle,applicantName,applicantUserName,applicantNote,applicantVoteButton,applicantVoterText,applicantVoterGroup
local flash
local backButton

-- widget event
local function getApplicant(applicantId)
    local data      = http.request("http://smart-life-web.herokuapp.com/api/ver1/candidate/"..applicantId)
    local applicant = json.decode(data)["candidate"]
    return applicant
end
local function voteApplicant(applicantId)
    -- http request
    local reqbody = "candidate_id="..applicantId
    respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/candidate_vote",
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


    applicantBackGround =  display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    applicantBackGround.anchorX = 0
    applicantBackGround.anchorY = 0

    applicantTitle = display.newText("applicant",screenW/2,50)
    applicantTitle:setFillColor( 0, 0, 0 )

    -- name
    applicantName = display.newText("name", screenW/2,90)
    applicantName:setFillColor( 0, 0, 0 )

    -- usr name
    applicantUserName = display.newText("user_name", screenW/2,120)
    applicantUserName:setFillColor( 0, 0, 0 )

    -- note
    applicantNote = display.newText("note", screenW/2,140)
    applicantNote:setFillColor( 0, 0, 0 )

    -- vote button
    applicantVoteButton = display.newImageRect( "imgs/bright_yellow_star.png",50,50)
    applicantVoteButton.x = screenW/2
    applicantVoteButton.y = 170

    -- voter
    applicantVoterText = display.newText("“Š•[ŽÒ",screenW/2,250)
    applicantVoterText:setFillColor( 0, 0, 0 )



    sceneGroup:insert( applicantBackGround )
    sceneGroup:insert( applicantTitle )
    sceneGroup:insert( applicantName )
    sceneGroup:insert( applicantUserName )
    sceneGroup:insert( applicantNote )
    sceneGroup:insert( applicantVoterText )
    sceneGroup:insert( applicantVoteButton )


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
        local applicantId = composer.getVariable("applicantId")
        local applicant = getApplicant(applicantId)

        applicantName.text = applicant["name"]
        applicantUserName.text = applicant["user_name"]
        applicantNote.text = applicant["note"]

        -- vote button
        local function onApplicantVote(event)
            voteApplicant(applicantId)
        end
        applicantVoteButton:addEventListener("touch", onApplicantVote)
        if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
            applicantVoteButton.isVisible = false
        else
            applicantVoteButton.isVisible = true
        end

        -- voter
        local voters = applicant["voters"]
        applicantVoterGroup = display.newGroup()
        for i=1,#voters do
            local applicantVoter = display.newText(applicantVoterGroup,voters[i]["name"],screenW/2,250+i*15)
            applicantVoter:setFillColor( 0, 0, 0 )
        end
        sceneGroup:insert( applicantVoterGroup )

    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then

    elseif phase == "did" then
        sceneGroup:remove(applicantVoterGroup)
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