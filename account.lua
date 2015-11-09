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
local accountBackground,userImage,userName,webSite,eMail,note
local flash

-- widget event
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

-- szene event
function scene:create( event )
    local sceneGroup = self.view

    print("account create")

    local userData = getUserAccount()

    accountBackground = display.newImageRect( "imgs/background.jpg", screenW, screenH-50 )
    accountBackground.anchorX = 0
    accountBackground.anchorY = 0

    userImage = display.newImageRect("imgs/account.jpg",50,50)
    userImage.x = screenW/2
    userImage.y = 100

    userName = display.newText(userData["user"]["name"],100,100)
    userName:setFillColor( 0, 0, 0 )

    webSite = display.newText( userData["user"]["website"],100,120)
    webSite:setFillColor( 0, 0, 0 )

    eMail = display.newText(userData["user"]["email"],100,140)
    eMail:setFillColor( 0, 0, 0 )

    note = display.newText(userData["user"]["note"],100,160)
    note:setFillColor( 0, 0, 0 )

    sceneGroup:insert( accountBackground )
    sceneGroup:insert( userImage )
    sceneGroup:insert( userName )
    sceneGroup:insert( webSite )
    sceneGroup:insert( eMail )
    sceneGroup:insert( note )

    flash = display.newText("",50,screenH-100)
    flash:setFillColor( 0, 0, 0 )
    flash.isVisible = false

    sceneGroup:insert( flash )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then

    elseif phase == "did" then
        -- Called when the scene is now on screen
    end

end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then

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