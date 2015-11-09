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
local backGround, text, text1, text2, text3, slider, button, button1,onOffSwitch

-- widget event


-- set widget listener


-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- backGround
    backGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    backGround.anchorX = 0
    backGround.anchorY = 0

    -- sample text
    text = display.newText("Setting", screenW/2, 82, nil, 50)
    --text.x,text.y = screenW/2,screenH/2
    text:setFillColor(0,0,0)
    
    text1 = display.newText("通知", screenW/2, 130, nil, 20)
    --text1.x,text1.y = screenW/2,screenH/2
    text1:setFillColor(0,0,0)

    text2 = display.newText("文字サイズ", screenW/2, 230, nil, 20)
    --text2.x,text2.y = screenW/2,screenH/2
    text2:setFillColor(0,0,0)
    
     text3 = display.newText("サポート", screenW/2, 330, nil, 20)
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
    	top = 250,
    	left = 50,
    	width = 200,
    	value = 10,  -- Start slider at 10% (optional)
    	listener = sliderListener
	}

    -- widget insert
    sceneGroup:insert( backGround )
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
    left = 130,
    top = 150,
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
button1.y = 370

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