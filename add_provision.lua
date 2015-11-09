--
-- Created by IntelliJ IDEA.
-- User: Taiga
-- Date: 2015/11/09
-- Time: 20:10
-- To change this template use File | Settings | File Templates.
--
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local backGround,titleText,nameBox,nameText,noteBox,noteText,sendButton
local backButton
local flash

-- widget event
local function createProvision()

    -- http
    local reqbody = "name="..nameBox.text.."&note="..noteBox.text.."&latitude="..composer.getVariable("latitude").."&longitude="..composer.getVariable("longitude")
    local respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/provision",
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
    local resp=json.decode(respbody[1])
    if(resp["error"] ~= nil) then
        flash.text = "you need login"
        flash.isVisible = true
    else
        flash.text = "success"
        flash.isVisible = true
    end
end
local function gotoMap()
    composer.gotoScene( "map_tab" )
end

-- scene event
function scene:create( event  )
    local sceneGroup = self.view

    backGround = display.newImageRect("imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0

    titleText = display.newText("Invitation",screenW/2,50)
    titleText:setFillColor( 0, 0, 0 )

    nameText = display.newText("name",50,100)
    nameText:setFillColor( 0, 0, 0 )
    nameBox  = native.newTextField(screenW/2+30,100,200,30)

    noteText = display.newText("note",50,140)
    noteText:setFillColor( 0, 0, 0 )
    noteBox  = native.newTextField(screenW/2+30,140,200,30)

    -- send button
    sendButton = display.newImageRect("imgs/send.png",120,40)
    sendButton.x = screenW -70
    sendButton.y = screenH -100
    local function onSendButton(event)
        createProvision()
    end
    sendButton:addEventListener("touch",onSendButton)

    sceneGroup:insert(backGround)
    sceneGroup:insert(titleText)
    sceneGroup:insert(nameText)
    sceneGroup:insert(nameBox)
    sceneGroup:insert(noteText)
    sceneGroup:insert(noteBox)
    sceneGroup:insert(sendButton)

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

    end
    if phase == "did" then
        nameBox.isVisible = true
        noteBox.isVisible = true
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        nameBox.isVisible = false
        noteBox.isVisible = false
    elseif phase == "did" then

    end
end
function scene:destroy( event )
    local sceneGroup = self.view
end

-- Add scene Listener
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

