-----------------------------------------------------------------------------------------
--
-- account.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")
local ltn12 = require'ltn12'


-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local backGround,login, emailBox, emailText, passwordBox, passwordText, passwordConfirmationBox, passwrdConfirmationText,sendButton

-- widget event
local function onSendButton(event)
    if(event.phase=="ended") then
        local emailText = emailBox.text
        local passwordText = passwordBox.text
        local passwordConfirmationText = passwordConfirmationBox.text
        print(emailText)
        print(passwordText)
        print(passwordConfirmationText)
        reqbody = [[email=test@test.com&password=123456789&password_confirmation=123456789]]
        response_body = {}
        socket.http.request{
            url = "http://smart-life-web.herokuapp.com/api/ver1/auth/sign_in",
            method = "POST",
            source = ltn12.source.string(reqbody),
            sink = ltn12.sink.table(response_body),
        }
        print(table.concat(response_body))

    end
end




-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    backGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0

    -- login text
    login = display.newText("Login",screenW/2,50)
    login:setFillColor( 0, 0, 0 )

    -- text fields
    emailBox = native.newTextField(screenW/2,130,200,30)
    emailText = display.newText("Email",screenW/2,100)
    emailText:setFillColor( 0, 0, 0 )

    passwordBox = native.newTextField(screenW/2,190,200,30)
    passwordBox.isSecure = true
    passwordText = display.newText("Password",screenW/2,160)
    passwordText:setFillColor( 0, 0, 0 )

    passwordConfirmationBox = native.newTextField(screenW/2,250,200,30)
    passwordConfirmationBox.isSecure = true
    passwrdConfirmationText = display.newText("Cofirm Password",screenW/2,220)
    passwrdConfirmationText:setFillColor( 0, 0, 0 )

    -- send button
    sendButton = display.newImageRect("imgs/send.png",120,40)
    sendButton.x = screenW -70
    sendButton.y = screenH -100
    sendButton:addEventListener("touch",onSendButton)

    -- widget insert
    sceneGroup:insert( backGround )
    sceneGroup:insert( login )
    sceneGroup:insert( emailBox )
    sceneGroup:insert( emailText )
    sceneGroup:insert( passwordBox )
    sceneGroup:insert( passwordText )
    sceneGroup:insert( passwordConfirmationBox )
    sceneGroup:insert( passwrdConfirmationText )
    sceneGroup:insert( sendButton )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        emailBox.isVisible = true
        passwordBox.isVisible = true
        passwordConfirmationBox.isVisible = true
    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
    elseif phase == "did" then
        emailBox.isVisible = false
        passwordBox.isVisible = false
        passwordConfirmationBox.isVisible = false

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