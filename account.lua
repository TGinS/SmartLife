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
local loginBackGround,loginText, loginEmailBox, loginEmailText, loginPasswordBox, loginPasswordText,loginSendButton,goRegistButton
local accountBackground,userImage,userName,webSite,eMail,note
local registBackGround,registText,registNameBox,registNameText,registEmailBox,registEmailText,registPasswordBox,registPasswordText,registPasswordConfirmationText,registPasswordConfirmationBox,registWebsiteBox,registWebsiteText,registNoteBox,registNoteText,registSendButton
local flash

-- widget event
local function reviveLogin()
    loginBackGround.isVisible   = true
    loginText.isVisible         = true
    loginEmailBox.isVisible     = true
    loginEmailText.isVisible    = true
    loginPasswordBox.isVisible  = true
    loginPasswordText.isVisible = true
    loginSendButton.isVisible   = true
    goRegistButton.isVisible    = true
    flash.isVisible             = false
end
local function reviveRegist()
    registBackGround.isVisible                  = true
    registText.isVisible                        = true
    registNameText.isVisible                    = true
    registNameBox.isVisible                     = true
    registEmailText.isVisible                   = true
    registEmailBox.isVisible                    = true
    registPasswordText.isVisible                = true
    registPasswordBox.isVisible                 = true
    registPasswordConfirmationText.isVisible    = true
    registPasswordConfirmationBox.isVisible     = true
    registWebsiteText.isVisible                 = true
    registWebsiteBox.isVisible                  = true
    registNoteText.isVisible                    = true
    registNoteBox.isVisible                     = true
    registSendButton.isVisible                  = true
    flash.isVisible                             = false
end
local function reviveAccount()
    accountBackground.isVisible = true
    userImage.isVisible         = true
    userName.isVisible          = true
    webSite.isVisible           = true
    eMail.isVisible             = true
    note.isVisible              = true
    flash.isVisible             = false
end

local function killLogin()
    loginBackGround.isVisible   = false
    loginText.isVisible         = false
    loginEmailBox.isVisible     = false
    loginEmailText.isVisible    = false
    loginPasswordBox.isVisible  = false
    loginPasswordText.isVisible = false
    loginSendButton.isVisible   = false
    goRegistButton.isVisible    = false
    flash.isVisible             = false
end
local function killRegist()
    registBackGround.isVisible                  = false
    registText.isVisible                        = false
    registNameText.isVisible                    = false
    registNameBox.isVisible                     = false
    registEmailText.isVisible                   = false
    registEmailBox.isVisible                    = false
    registPasswordText.isVisible                = false
    registPasswordBox.isVisible                 = false
    registPasswordConfirmationText.isVisible    = false
    registPasswordConfirmationBox.isVisible     = false
    registWebsiteText.isVisible                 = false
    registWebsiteBox.isVisible                  = false
    registNoteText.isVisible                    = false
    registNoteBox.isVisible                     = false
    registSendButton.isVisible                  = false
    flash.isVisible                             = false
end
local function killAccount()
    accountBackground.isVisible = false
    userImage.isVisible         = false
    userName.isVisible          = false
    webSite.isVisible           = false
    eMail.isVisible             = false
    note.isVisible              = false
    flash.isVisible             = false
end

local function displayLogin()
    killRegist()
    killAccount()
    reviveLogin()
end
local function displayAccount()
    killLogin()
    killRegist()
    reviveAccount()
end
local function displayRegist()
    killLogin()
    killAccount()
    reviveRegist()
end

local function getUserAccount()
    local respbody = {}
    local body, code, headers, status = http.request{
        url = "http://smart-life-web.herokuapp.com/api/ver1/account",
        method = "GET",
        headers =
        {
            ["Accept"] = "*/*",
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Uid"] = userInfo["uId"],
            ["Access-token"] = userInfo["accessToken"]
        },
        sink = ltn12.sink.table(respbody)
    }

    local userData=json.decode(respbody[1])

    return userData

end
local function setUserAccount(userData)
    userName.text = userData["user"]["name"]
    webSite.text = userData["user"]["website"]
    eMail.text = userData["user"]["email"]
    note.text = userData["user"]["note"]
end
local function getUserInfo()
    -- get text
    local emailText = loginEmailBox.text
    local passwordText = loginPasswordBox.text

    -- http request
    local reqbody = "email="..emailText.."&password="..passwordText
    respbody = {}
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

local function sceneInitialize()
    if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
        displayLogin()
    else
        local userData = getUserAccount()
        setUserAccount(userData)
        displayAccount()
    end
end

local function onLoginSendButton(event)
    if(event.phase=="ended") then
        getUserInfo()
        if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
            print("info is null")
            sceneInitialize()
            flash.text = "Failed"
            flash.isVisible = true

        else
            sceneInitialize()

        end
    end
end

local function createUser()
    -- http request
    print(registNameBox.text)
    print(registWebsiteBox.text)
    print(registNoteBox.text)

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
        print("info is")
        flash.text = "Failed"
        flash.isVisible = true
    else
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
    loginSendButton:addEventListener("touch",onLoginSendButton)

    --regist button
    goRegistButton = display.newText("Regist",screenW-50,50)
    goRegistButton:setFillColor( 0, 0, 0 )
    local function onGoRegist(event)
        displayRegist()
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
        sceneInitialize()

    elseif phase == "did" then
        -- Called when the scene is now on screen
    end

end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        killLogin()
        killAccount()
        killRegist()
    elseif phase == "did" then

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