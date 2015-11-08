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
local loginBackGround,loginText, emailBox, emailText, passwordBox, passwordText, passwordConfirmationBox, passwrdConfirmationText,sendButton
local accountBackground,userImage,userName,webSite,eMail,note

-- widget event
local function displayLogin()
    loginBackGround.isVisible = true
    loginText.isVisible                 = true
    emailBox.isVisible                  = true
    emailText.isVisible                 = true
    passwordBox.isVisible               = true
    passwordText.isVisible              = true
    passwordConfirmationBox.isVisible   = true
    passwrdConfirmationText.isVisible   = true
    sendButton.isVisible                = true
    accountBackground.isVisible         = false
    userImage.isVisible                 = false
    userName.isVisible                  = false
    webSite.isVisible                   = false
    eMail.isVisible                     = false
    note.isVisible                      = false
end
local function displayAccount()
    loginBackGround.isVisible           = false
    loginText.isVisible                 = false
    emailBox.isVisible                  = false
    emailText.isVisible                 = false
    passwordBox.isVisible               = false
    passwordText.isVisible              = false
    passwordConfirmationBox.isVisible   = false
    passwrdConfirmationText.isVisible   = false
    sendButton.isVisible                = false
    accountBackground.isVisible         = true
    userImage.isVisible                 = true
    userName.isVisible                  = true
    webSite.isVisible                   = true
    eMail.isVisible                     = true
    note.isVisible                      = true
    print(userInfo["uId"])
    print(userInfo["accessToken"])
end
local function getUserAccount()
    print("get account info via api")
end
local function sceneInitialize()

    if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
        displayLogin()
    else
        getUserAccount()
        displayAccount()
    end
end
local function getUserInfo()
    -- get text
    local emailText = emailBox.text
    local passwordText = passwordBox.text
    local passwordConfirmationText = passwordConfirmationBox.text

    -- http request
    local reqbody = "email="..emailText.."&password="..passwordText.."&password_confirmation="..passwordConfirmationText
    local respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/auth/sign_in",
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

    -- get user info
    userInfo["uId"]         = headers["uid"]
    userInfo["accessToken"] = headers["access-token"]
end
local function onSendButton(event)
    if(event.phase=="ended") then
        getUserInfo()
        sceneInitialize()
    end
end


-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    loginBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    loginBackGround.anchorX = 0
    loginBackGround.anchorY = 0

    -- login text
    loginText = display.newText("Login",screenW/2,50)
    loginText:setFillColor( 0, 0, 0 )

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
    sceneGroup:insert( loginBackGround )
    sceneGroup:insert( loginText )
    sceneGroup:insert( emailBox )
    sceneGroup:insert( emailText )
    sceneGroup:insert( passwordBox )
    sceneGroup:insert( passwordText )
    sceneGroup:insert( passwordConfirmationBox )
    sceneGroup:insert( passwrdConfirmationText )
    sceneGroup:insert( sendButton )

    accountBackground = display.newImageRect( "imgs/background.jpg", screenW, screenH-50 )
    accountBackground.anchorX = 0
    accountBackground.anchorY = 0

    userImage = display.newImageRect("imgs/account.jpg",50,50)
    userImage.x = screenW/2
    userImage.y = 100

    userName = display.newText("dummy",100,100)
    userName:setFillColor( 0, 0, 0 )

    webSite = display.newText("dummy",100,120)
    webSite:setFillColor( 0, 0, 0 )

    eMail = display.newText("dummy",100,140)
    eMail:setFillColor( 0, 0, 0 )

    note = display.newText("dummy",100,160)
    note:setFillColor( 0, 0, 0 )

    sceneGroup:insert( accountBackground )
    sceneGroup:insert( userImage )
    sceneGroup:insert( userName )
    sceneGroup:insert( webSite )
    sceneGroup:insert( eMail )
    sceneGroup:insert( note )
end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        sceneInitialize()

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