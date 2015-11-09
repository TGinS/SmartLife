-----------------------------------------------------------------------------------------
--
-- login.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local loginBackGround,loginText, loginEmailBox, loginEmailText, loginPasswordBox, loginPasswordText,loginSendButton,goRegistButton
local flash

-- widget event
local function getTokens()
    -- get text
    local emailText = loginEmailBox.text
    local passwordText = loginPasswordBox.text

    -- http request
    local reqbody = "email="..emailText.."&password="..passwordText
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
local function login()
        getTokens()
        if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
            flash.text = "Failed"
            flash.isVisible = true
        else
            composer.gotoScene("account")
        end
end
local function gotoRegistration()
    composer.gotoScene("registration")
end

-- set widget listener


-- scene event
function scene:create( event )
    local sceneGroup = self.view
    print("login create")
    -- backGround
    -- backGround
    loginBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    loginBackGround.anchorX = 0
    loginBackGround.anchorY = 0

    -- login text
    loginText = display.newText("Login",screenW/2,50)
    loginText:setFillColor( 0, 0, 0 )

    -- text fields
    loginEmailBox = native.newTextField(screenW/2,130,200,30)
    loginEmailText = display.newText("Email",screenW/2,100)
    loginEmailText:setFillColor( 0, 0, 0 )

    loginPasswordBox = native.newTextField(screenW/2,190,200,30)
    loginPasswordBox.isSecure = true
    loginPasswordText = display.newText("Password",screenW/2,160)
    loginPasswordText:setFillColor( 0, 0, 0 )

    -- send button
    loginSendButton = display.newImageRect("imgs/send.png",120,40)
    loginSendButton.x = screenW -70
    loginSendButton.y = screenH -100
    local function onLoginSend(event)
        login()
    end
    loginSendButton:addEventListener("touch",onLoginSend)

    --regist button
    goRegistButton = display.newText("Regist",screenW-50,50)
    goRegistButton:setFillColor( 0, 0, 0 )
    local function onGoRegist(event)
        gotoRegistration()
    end
    goRegistButton:addEventListener("touch",onGoRegist)

    -- widget insert
    sceneGroup:insert( loginBackGround )
    sceneGroup:insert( loginText )
    sceneGroup:insert( loginEmailBox )
    sceneGroup:insert( loginEmailText )
    sceneGroup:insert( loginPasswordBox )
    sceneGroup:insert( loginPasswordText )
    sceneGroup:insert( loginSendButton )
    sceneGroup:insert( goRegistButton )


    flash = display.newText("",50,screenH-100)
    flash:setFillColor( 0, 0, 0 )
    flash.isVisible = false

    sceneGroup:insert( flash )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        loginEmailBox.isVisible = true
        loginPasswordBox.isVisible = true
    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        loginEmailBox.isVisible = false
        loginPasswordBox.isVisible = false
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