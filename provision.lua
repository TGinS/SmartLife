-----------------------------------------------------------------------------------------
--
-- provision.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local json = require "json"
local http = require("socket.http")

-- declare var
local screenW, screenH = display.contentWidth, display.contentHeight
local provisionBackGround,provisionTitle,provisionName,provisionUserName,provisionNote,applyButton,applicantListTitle,applicantsGroup,map
local flash
local backButton

-- widget event
local function getProvision(id)
    local data              = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision/"..id)
    local provision         = json.decode(data)["provision"]
    return provision
end
local function getApplicants(provisionId)
    local applicants_data = http.request("http://smart-life-web.herokuapp.com/api/ver1/provision/"..provisionId.."/candidate")
    local applicants = json.decode(applicants_data)["candidates"]
    return applicants
end
local function gotoApply(id)
    composer.setVariable("provisionId",id)
    composer.gotoScene("apply")
end
local function gotoApplicant(id)
    composer.setVariable("applicantId",id)
    composer.gotoScene("applicant")
end
local function gotoMap()
    composer.gotoScene( "map_tab" )
end

-- scene event
function scene:create( event )
    local sceneGroup = self.view

    -- back
    provisionBackGround = display.newImageRect( "imgs/background.jpg", display.contentWidth, display.contentHeight )
    provisionBackGround.anchorX = 0
    provisionBackGround.anchorY = 0

    provisionTitle = display.newText("’ñ‹Ÿ",screenW/2,50)
    provisionTitle:setFillColor( 0, 0, 0 )

    -- name
    provisionName = display.newText("name", screenW/2,90)
    provisionName:setFillColor( 0, 0, 0 )

    -- usr name
    provisionUserName = display.newText("user_name", screenW/2,120)
    provisionUserName:setFillColor( 0, 0, 0 )

    -- note
    provisionNote = display.newText("note", screenW/2,140)
    provisionNote:setFillColor( 0, 0, 0 )

    --map
    map = native.newMapView( 20, 20, screenW-100, 100 )
    map.x = screenW/2
    map.y = 220
    map:setRegion(34.7216618061847,137.739935164062,0.05,0.05,false)
    map.mapType = "standard"
    map.isLocationVisible=false

    -- apply button
    applyButton = display.newImageRect("imgs/apply.jpg",100,50)
    applyButton.x =screenW - screenW/5
    applyButton.y = screenH-80

    -- applicant list title
    applicantListTitle = display.newText("applicants",screenW/2,290)
    applicantListTitle:setFillColor( 0, 0, 0 )
    applicantListTitle.isVisible =  true

    sceneGroup:insert( provisionBackGround )
    sceneGroup:insert( provisionTitle )
    sceneGroup:insert( provisionName )
    sceneGroup:insert( provisionUserName )
    sceneGroup:insert( provisionNote )
    sceneGroup:insert( map )
    sceneGroup:insert( applicantListTitle )
    sceneGroup:insert( applyButton )

    -- back button
    backButton = display.newImageRect("imgs/back-button.png",50,50)
    backButton.x = 30
    backButton.y = 30
    local function onBackButton()
        gotoMap()
    end
    backButton:addEventListener("touch",onBackButton)

    -- flash text
    flash = display.newText("",screenW-50,screenH-100)
    flash:setFillColor( 0, 0, 0 )


    sceneGroup:insert( backButton )
    sceneGroup:insert( flash )

end
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        local provisionId = composer.getVariable("provisionId")
        local provision = getProvision(provisionId)

        -- set text
        provisionName.text = provision["name"]
        provisionUserName.text = provision["user_name"]
        provisionNote.text = provision["note"]

        -- set listener applyButton
        local function onApplyButton()
            gotoApply(provisionId)
        end
        applyButton:addEventListener("touch",onApplyButton)

        -- set applicant group
        local applicants = getApplicants(provisionId)
        applicantsGroup = display.newGroup()
        for i=1,#applicants do
            local applicantId = display.newText(applicantsGroup,applicants[i]["id"],screenW/4,290+i*20)
            applicantId:setFillColor( 0, 0, 0 )
            local applicantName = display.newText(applicantsGroup,applicants[i]["name"],screenW/2,290+i*20)
            applicantName:setFillColor( 0, 0, 0 )
            local applicantRight = display.newImageRect(applicantsGroup,"imgs/right.jpg",25,25)
            applicantRight.x,applicantRight.y = screenW-40,290+i*20
            local function onApplicantRight(event)
                if(event.phase=="ended") then
                    gotoApplicant(applicants[i]["id"])
                end
            end
            applicantRight:addEventListener("touch",onApplicantRight)
        end
        sceneGroup:insert( applicantsGroup )

        map.isVisible = true
        local options =
        {
            title = provision["name"],
            subtitle = "’ñ‹Ÿ",
            -- This will look in the resources directory for the image file
            -- Alternatively, this looks in the specified directory for the image file
            -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
        }
        map:addMarker(provision["latitude"], provision["longitude"],options)
        map:setCenter(provision["latitude"],provision["longitude"])

    elseif phase == "did" then
        -- Called when the scene is now on screen
    end
end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        map:removeAllMarkers()
        map.isVisible = false

    elseif phase == "did" then
        --remove applicant group
        sceneGroup:remove(applicantsGroup)
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