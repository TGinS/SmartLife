-----------------------------------------------------------------------------------------
--
-- registration.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local http = require("socket.http")
local ltn12 = require'ltn12'

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local registBackGround,registText,registNameBox,registNameText,registEmailBox,registEmailText,registPasswordBox,registPasswordText,registPasswordConfirmationText,registPasswordConfirmationBox,registWebsiteBox,registWebsiteText,registNoteBox,registNoteText,registSendButton
local flash

-- widget event
local function createUser()
    -- http request
    local reqbody = "name="..registNameBox.text.."&website="..registWebsiteBox.text.."&note="..registNoteBox.text.."&email="..registEmailBox.text.."&password="..registPasswordBox.text.."&password_confirmation="..registPasswordConfirmationBox.text
    respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/auth",
        method = "POST",
        headers =
        {
            ["Accept"] = "*/*",
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["content-length"] = string.len(reqbody)
        },
        source = ltn12.source.string(reqbody),
        sink = ltn12.sink.table(respbody)
    }
    print(table.concat(respbody))

    -- get user info
    userInfo["uId"]         = headers["uid"]
    userInfo["accessToken"] = headers["access-token"]
end
local function onRegistSendButton(event)
    createUser()
    if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
        flash.text = "Failed"
        flash.isVisible = true
    else
        composer.gotoScene("account")
    end
end

-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    registBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight)
    registBackGround.anchorX = 0
    registBackGround.anchorY = 0

    registText = display.newText("Registration",screenW/2,50)
    registText:setFillColor( 0, 0, 0 )

    registNameText = display.newText("name",50,100)
    registNameText:setFillColor( 0, 0, 0 )
    registNameBox  = native.newTextField(screenW/2+30,100,200,30)

    registEmailText = display.newText("Email",50,140)
    registEmailText:setFillColor( 0, 0, 0 )
    registEmailBox  = native.newTextField(screenW/2+30,140,200,30)

    registPasswordText = display.newText("Pass",50,180)
    registPasswordText:setFillColor( 0, 0, 0 )
    registPasswordBox  = native.newTextField(screenW/2+30,180,200,30)
    registPasswordBox.isSecure = true

    registPasswordConfirmationText = display.newText("confirm",50,220)
    registPasswordConfirmationText:setFillColor( 0, 0, 0 )
    registPasswordConfirmationBox  = native.newTextField(screenW/2+30,220,200,30)
    registPasswordConfirmationBox.isSecure = true

    registWebsiteText = display.newText("website",50,260)
    registWebsiteText:setFillColor( 0, 0, 0 )
    registWebsiteBox  = native.newTextField(screenW/2+30,260,200,30)

    registNoteText = display.newText("note",50,300)
    registNoteText:setFillColor( 0, 0, 0 )
    registNoteBox  = native.newTextField(screenW/2+30,300,200,30)

    -- send button
    registSendButton = display.newImageRect("imgs/send.png",120,40)
    registSendButton.x = screenW -70
    registSendButton.y = screenH -100
    registSendButton:addEventListener("touch",onRegistSendButton)

    sceneGroup:insert(registBackGround)
    sceneGroup:insert(registText)
    sceneGroup:insert(registNameText)
    sceneGroup:insert(registNameBox)
    sceneGroup:insert(registEmailText)
    sceneGroup:insert(registEmailBox)
    sceneGroup:insert(registPasswordText)
    sceneGroup:insert(registPasswordBox)
    sceneGroup:insert(registPasswordConfirmationText)
    sceneGroup:insert(registPasswordConfirmationBox)
    sceneGroup:insert(registWebsiteText)
    sceneGroup:insert(registWebsiteBox)
    sceneGroup:insert(registNoteText)
    sceneGroup:insert(registNoteBox)
    sceneGroup:insert(registSendButton)


    flash = display.newText("",50,screenH-100)
    flash:setFillColor( 0, 0, 0 )
    flash.isVisible = false

    sceneGroup:insert( flash )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        registNameBox.isVisible =                   true
        registEmailBox.isVisible =                  true
        registPasswordBox.isVisible =               true
        registPasswordConfirmationBox.isVisible = true
        registWebsiteBox.isVisible =                true
        registNoteBox.isVisible =                   true
        registNameBox.isVisible =                   true
    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if event.phase == "will" then
        registNameBox.isVisible =                   false
        registEmailBox.isVisible =                  false
        registPasswordBox.isVisible =               false
        registPasswordConfirmationBox.isVisible = false
        registWebsiteBox.isVisible =                false
        registNoteBox.isVisible =                   false
        registNameBox.isVisible =                   false
    elseif phase == "did" then
        -- Called when the scene is now off screen
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