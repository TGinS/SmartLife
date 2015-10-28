-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--メインです

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"


-- event listeners for tab buttons:
local function onFirstView( event )
    composer.gotoScene( "ranking" )
end
local function onSecondView( event )
    composer.gotoScene( "map" )
end
local function onThirdView( event )
    composer.gotoScene( "setting" )
end
local function onFourthView( event )
    composer.gotoScene( "account" )
end


-- table to setup buttons
local tabButtons = {
    { label="Ranking", defaultFile="imgs/1.png", overFile="imgs/1.png", width = 32, height = 32, onPress=onFirstView },
    { label="Map",     defaultFile="imgs/2.png", overFile="imgs/2.png", width = 32, height = 32, onPress=onSecondView, selected = true },
    { label="Setting", defaultFile="imgs/3.png", overFile="imgs/3.png", width = 32, height = 32, onPress=onThirdView },
    { label="Account", defaultFile="imgs/4.png", overFile="imgs/4.png", width = 32, height = 32, onPress=onFourthView },
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
    top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
    buttons = tabButtons
}

onSecondView()	-- invoke Second tab button's onPress event manually