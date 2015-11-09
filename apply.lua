-----------------------------------------------------------------------------------------
--
-- apply.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local applyBackGround,applyTitle,nameText,nameBox,noteText,noteBox,sendButton
local flash
local backButton

-- widget event
local function createApplicant()
    local provisionId = composer.getVariable("provisionId")
    -- http request
    local reqbody = "name="..nameBox.text.."&note="..noteBox.text.."&provision_id="..provisionId
    local respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/candidate",
        method = "POST",
        headers =
        {
            ["Accept"] = "*/*",
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["content-length"] = string.len(reqbody),
            ["Uid"] = userInfo["uId"],
            ["Access-token"] = userInfo["accessToken"]
        },
        source = ltn12.source.string(reqbody),
        sink = ltn12.sink.table(respbody)
    }
    print(table.concat(respbody))
    local resp=json.decode(respbody[1])
    if(resp["error"] ~= nil) then
        flash.text = "you need login"
        flash.isVisible = true
    else
        flash.text = "success"
        flash.isVisible = true
    end

    --remove listener
    --sendButton._functionListeners = nil
    --sendButton._tableListeners = nil
end
local function gotoMap()
    composer.gotoScene( "map_tab" )
end

-- scene event
function scene:create( event )
    local sceneGroup = self.view


    -- back
    applyBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    applyBackGround.anchorX = 0
    applyBackGround.anchorY = 0

    -- title
    applyTitle = display.newText("‰ž•å",screenW/2,50)
    applyTitle:setFillColor( 0, 0, 0 )

    -- name
    nameBox = native.newTextField(screenW/2,130,200,30)
    nameText = display.newText("name",screenW/2,100)
    nameText:setFillColor( 0, 0, 0 )

    -- note
    noteBox = native.newTextField(screenW/2,190,200,30)
    noteText = display.newText("note",screenW/2,160)
    noteText:setFillColor( 0, 0, 0 )

    -- send button
    sendButton = display.newImageRect("imgs/send.png",120,40)
    sendButton.x = screenW -70
    sendButton.y = screenH -100
    local function onSendButton(event)
        createApplicant()
    end
    sendButton:addEventListener("touch",onSendButton)

    sceneGroup:insert( applyBackGround )
    sceneGroup:insert( applyTitle )
    sceneGroup:insert( nameBox )
    sceneGroup:insert( nameText )
    sceneGroup:insert( noteBox )
    sceneGroup:insert( noteText )
    sceneGroup:insert( sendButton )

    -- back button
    backButton = display.newImageRect("imgs/back-button.png",50,50)
    backButton.x = 30
    backButton.y = 30
    local function onBackButton()
        gotoMap()
    end
    backButton:addEventListener("touch",onBackButton)

    -- flash text
    flash = display.newText("",50,screenH-100)
    flash:setFillColor( 0, 0, 0 )

    sceneGroup:insert( backButton )
    sceneGroup:insert( flash )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        nameBox.isVisible = true
        noteBox.isVisible = true

    elseif phase == "did" then

        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        nameBox.isVisible = false
        noteBox.isVisible = false
    elseif phase == "did" then
        --remove applicant group

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