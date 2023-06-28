local pd <const> = playdate
local gfx <const> = Graphics

Title = {}
class("Title").extends(BaseScene)

-- This can be initialized at boot
local logo = gfx.sprite.new(gfx.image.new("/assets/images/logo"))
logo:moveTo(200, 90)
local playerSlot
local menu
local crankTick = 0

-- Add menu controls to the scene's input handler
Title.inputHandler = {
	upButtonDown = function()
		menu:selectPrevious()
	end,
	downButtonDown = function()
		menu:selectNext()
	end,
	cranked = function(change, _)
		crankTick = crankTick + change
		if crankTick > 30 then
			crankTick = 0
			menu:selectNext()
		elseif crankTick < -30 then
			crankTick = 0
			menu:selectPrevious()
		end
	end,
	AButtonDown = function()
		menu:click()
	end
}

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitioning away from another scene.
function Title:init()
	Title.super.init(self)

    Noble.Text.setFont(Noble.Text.FONT_NEWSLEAK) -- Menus use the Noble font
    menu = Noble.Menu.new(
        true,  -- Activate
        Noble.Text.ALIGN_CENTER,
        false,  -- No localization
        nil,  -- Use default color
        4, 6  -- Adjust padding
    )
    menu:addItem("Play", function() Noble.transition(Play) end)
    menu:addItem("Stats", function() Noble.transition(Stats) end)
    menu:select("Play")

	-- Add menu item to change the save slot
	playerSlot = tonumber(Noble.Settings.get("playerSlot"))
    self.menu:addOptionsMenuItem(
        "Save",
        { 1, 2, 3, 4 },
        playerSlot,
		function(value)
            Noble.Settings.set("playerSlot", value)
			Noble.GameData.save(tonumber(value))
		end
	)
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function Title:enter()
    Title.super.enter(self)

	self:addSprite(logo)
end

-- This runs once per frame.
function Title:update()
    Title.super.update(self)

    menu:draw(200, 160)
end
