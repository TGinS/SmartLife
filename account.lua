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
local accountBackground,userImage,userName,webSite,eMail,note,result

-- widget event
function dump_data(data, deep, multiline_style)
    local INDENT_STR = "    "

    if (type(data) ~= "table") then
        return tostring(data)
    end

    local dump_table

    if (not multiline_style) then
        dump_table = function(t, deep)
            local str = "{"

            if (deep) then
                for k, v in pairs(t) do
                    if (type(v) == "table") then
                        str = string.format("%s%s = %s, ",
                            str, tostring(k), dump_table(v, true))
                    elseif (type(v) == "string") then
                        str = string.format("%s%s = %q, ", str, tostring(k), v)
                    else
                        str = string.format("%s%s = %s, ", str, tostring(k), tostring(v))
                    end
                end
            else
                for k, v in pairs(t) do
                    if (type(v) == "string") then
                        str = string.format("%s%s = %q, ", str, tostring(k), v)
                    else
                        str = string.format("%s%s = %s, ", str, tostring(k), tostring(v))
                    end
                end
            end

            str = str .. "}"

            return str
        end
    else
        dump_table = function(t, deep, indent)
            local str = "{\n"

            if (deep) then
                for k, v in pairs(t) do
                    if (type(v) == "table") then
                        str = string.format("%s%s%s%s = %s,\n",
                            str, indent, INDENT_STR, tostring(k),
                            dump_table(v, true, indent .. INDENT_STR))
                    elseif (type(v) == "string") then
                        str = string.format("%s%s%s%s = %q,\n",
                            str, indent, INDENT_STR, tostring(k), v)
                    else
                        str = string.format("%s%s%s%s = %s,\n",
                            str, indent, INDENT_STR, tostring(k), tostring(v))
                    end
                end
            else
                for k, v in pairs(t) do
                    if (type(v) == "string") then
                        str = string.format("%s%s%s%s = %q,\n",
                            str, indent, INDENT_STR, tostring(k), v)
                    else
                        str = string.format("%s%s%s%s = %s,\n",
                            str, indent, INDENT_STR, tostring(k), tostring(v))
                    end
                end
            end

            str = str .. indent .. "}"

            return str
        end
    end

    return dump_table(data, deep, "")
end
local function displayLogin()
    print("display login")
    loginBackGround.isVisible = true
    loginText.isVisible                 = true
    emailBox.isVisible                  = true
    emailText.isVisible                 = true
    passwordBox.isVisible               = true
    passwordText.isVisible              = true
    passwordConfirmationBox.isVisible   = true
    passwrdConfirmationText.isVisible   = true
    sendButton.isVisible                = true
    result.isVisible                    = false
    accountBackground.isVisible         = false
    userImage.isVisible                 = false
    userName.isVisible                  = false
    webSite.isVisible                   = false
    eMail.isVisible                     = false
    note.isVisible                      = false
end
local function displayAccount()
    print("display Account")
    loginBackGround.isVisible           = false
    loginText.isVisible                 = false
    emailBox.isVisible                  = false
    emailText.isVisible                 = false
    passwordBox.isVisible               = false
    passwordText.isVisible              = false
    passwordConfirmationBox.isVisible   = false
    passwrdConfirmationText.isVisible   = false
    sendButton.isVisible                = false
    result.isVisible                    = false
    accountBackground.isVisible         = true
    userImage.isVisible                 = true
    userName.isVisible                  = true
    webSite.isVisible                   = true
    eMail.isVisible                     = true
    note.isVisible                      = true
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

    for key,val in pairs(userData["user"]) do
        print(key, val)
    end
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
        print("will get info")
        getUserInfo()
        print("did get info")
        if(userInfo["uId"]==nil or userInfo["accessToken"]==nil) then
            print("info is null")
            sceneInitialize()
            result.isVisible = true

        else
            sceneInitialize()

        end
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

    result = display.newText("Login Failed",screenW/2,300)
    result:setFillColor( 0, 0, 0 )
    result.isVisible = false

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
    sceneGroup:insert( result )


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