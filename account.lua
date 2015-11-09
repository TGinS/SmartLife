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
local accountBackground,userImage,userName,webSite,eMail,note,text,text1,text2,text3
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

    userImage = display.newImageRect("imgs/account.jpg",100,100)
    userImage.x = screenW/2
    userImage.y = 100

    userName = display.newText(userData["user"]["name"],160,180,nil,25)
    userName:setFillColor( 0, 0, 0 )
    text = display.newText("名前", 80, 160)
    --text.x,text.y = screenW/2,screenH/2
    text:setFillColor(0,0,0)

    webSite = display.newText( userData["user"]["website"],160,240,nil,25)
    webSite:setFillColor( 0, 0, 0 )
     text1 = display.newText("ホームページ", 80, 210)
    --text.x,text.y = screenW/2,screenH/2
    text1:setFillColor(0,0,0)

    eMail = display.newText(userData["user"]["email"],160,300,nil,25)
    eMail:setFillColor( 0, 0, 0 )
     text2 = display.newText("メールアドレス", 80, 270)
    --text.x,text.y = screenW/2,screenH/2
    text2:setFillColor(0,0,0)

    note = display.newText(userData["user"]["note"],160,360,nil,25)
    note:setFillColor( 0, 0, 0 )
     text3 = display.newText("その他", 80, 330)
    --text.x,text.y = screenW/2,screenH/2
    text3:setFillColor(0,0,0)

    sceneGroup:insert( accountBackground )
    sceneGroup:insert( userImage )
    sceneGroup:insert( userName )
    sceneGroup:insert( webSite )
    sceneGroup:insert( eMail )
    sceneGroup:insert( note )
    sceneGroup:insert( text )
    sceneGroup:insert( text1 )
    sceneGroup:insert( text2 )
    sceneGroup:insert( text3 )


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