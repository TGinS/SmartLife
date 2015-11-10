-----------------------------------------------------------------------------------------
--
-- setting_tab.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"


-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local backGround, text, text1, text2, text3, slider, button, button1,onOffSwitch, line

-- widget event


-- set widget listener


-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    backGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0

    --line
    line = display.newImageRect( "imgs/line.png", 500, 70)
    line.x = screenW-100
    line.y = screenH-460


    -- sample text
    text = display.newText("設定", screenW/5, screenH/15, nil, 35)
    --text.x,text.y = screenW/2,screenH/2
    text:setFillColor(1,1,1)
    
    text1 = display.newText("通知", screenW/4, 120, nil, 15)
    --text1.x,text1.y = screenW/2,screenH/2
    text1:setFillColor(0,0,0)

    text2 = display.newText("文字サイズ", screenW/3.2, 210, nil, 15)
    --text2.x,text2.y = screenW/2,screenH/2
    text2:setFillColor(0,0,0)
    
     text3 = display.newText("サポート", screenW/3.5, 300, nil, 15)
    --text3.x,text3.y = screenW/2,screenH/2
    text3:setFillColor(0,0,0)

	-----charactersize
	-- Slider listener
	local function sliderListener( event )
    	print( "Slider at " .. event.value .. "%" )
	end

	-- Create the widget
	slider = widget.newSlider
	{	
    	top = 220,
    	left = 60,
    	width = 200,
    	value = 10,  -- Start slider at 10% (optional)
    	listener = sliderListener
	}

    -- widget insert
    sceneGroup:insert( backGround )
    sceneGroup:insert( line )
    sceneGroup:insert( text )
    sceneGroup:insert( text1 )
	sceneGroup:insert( slider )
	sceneGroup:insert( text2 )
	sceneGroup:insert( text3 )
	--sceneGroup:insert( button )
    sceneGroup:insert( button1 )
    sceneGroup:insert( onOffSwitch)
    
end

local widget = require( "widget" )

-----notification
-- Handle press events for the checkbox
local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
end

-- Create the widget
onOffSwitch = widget.newSwitch
{
    left = 55,
    top = 130,
    style = "onOff",
    id = "onOffSwitch",
    onPress = onSwitchPress
}

-----help

-- Create the widget
button1 = widget.newButton
{
    label = "button",
    onEvent = handleButtonEvent,
    emboss = false,
    --properties for a rounded rectangle button...
    shape="roundedRect",
    width = 200,
    height = 40,
    cornerRadius = 2,
    fillColor = { default={ 0, 0, 0, 0 }, over={ 0, 0.1, 7, 0.4 } },
    strokeColor = { default={ 0, 4, 5, 1 }, over={ 0.8, 0.8, 1, 1 } },
    strokeWidth = 4
}

-- Center the button
button1.x = 160
button1.y = 340

-- Change the button's label text
button1:setLabel( "Help" )


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
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