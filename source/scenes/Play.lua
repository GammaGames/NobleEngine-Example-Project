local pd <const> = playdate
local gfx <const> = Graphics

Play = {}
class("Play").extends(BaseScene)

local items
local itemTimer
local player
local playerSlot
local ground <const> = gfx.image.new("/assets/images/ground")
local tree <const> = gfx.image.new("/assets/images/tree")
local grass <const> = gfx.image.new("/assets/images/grass")
local collected = 0

-- Input is mostly handled by the player
Play.inputHandler = {
	BButtonHeld = function()
		Noble.GameData.set("items", items, playerSlot)  -- Save the player's collected items
		Noble.transition(Title)
	end
}

function Play:init()
    Play.super.init(self)

	collected = 0
	playerSlot = tonumber(Noble.Settings.get("playerSlot"))
	items = Noble.GameData.get("items", playerSlot)
	player = Player(100, 96, playerSlot)
    self.menu:addMenuItem("menu", function() Noble.transition(Title) end)
end

function Play:enter()
    Play.super.enter(self)

	-- Using regular sprites because of convenience
	local tree_sprite = gfx.sprite.new(tree)
	tree_sprite:setCenter(0.5, 1)  -- This sets the anchor to the bottom center
	tree_sprite:moveTo(144, 104)
	self:addSprite(tree_sprite)

	local bush_sprite = gfx.sprite.new(tree)  -- This sprite is centered at 0.5, 0.5
	bush_sprite:moveTo(32, 100)
	self:addSprite(bush_sprite)

	local grass1 = gfx.sprite.new(grass)
	grass1:setCenter(0.5, 1)
	grass1:moveTo(50, 105)
	self:addSprite(grass1)
	local grass2 = gfx.sprite.new(grass)
	grass2:setCenter(0.5, 1)
	grass2:moveTo(130, 105)
	self:addSprite(grass2)

	local ground_sprite = gfx.sprite.new(ground)
	ground_sprite:setCenter(0.5, 0)  -- This sets the anchor to the top center
	ground_sprite:moveTo(100, 104)
	self:addSprite(ground_sprite)

	self:addSprite(player)
	player.active = true  -- Setting active sets the state, so we don't set it until the scene enters
	playdate.display.setScale(2)  -- Set the screen scale so the 16x16 pixels are bigger
end

function Play:collectItem(_, value)
	collected += 1
	local key = tostring(value)  -- Convert to string so the items work like a dictionary and not an array
	if items[key] == nil then
		items[key] = 0
	end
	items[key] += 1
end

-- This runs once a transition from another scene is complete.
function Play:start()
    Play.super.start(self)

	Noble.showFPS = true
	Signal:add("collected", self, self.collectItem)  -- Add our callback when an item is collected
	itemTimer = Timer.new(1000, function()  -- Once a second, spawn an item at a random position
		Item(math.random(10, 190), -10)
    end)
	itemTimer.repeats = true
end

-- This runs as as soon as a transition to another scene begins.
function Play:exit()
    Play.super.exit(self)

	Noble.showFPS = false
	itemTimer:remove()
	Signal:remove("collected", self.collectItem)
	Noble.GameData.set("items", items, playerSlot)  -- Save the player's collected items
end

-- This runs once a transition to another scene completes.
function Play:finish()
	Play.super.finish(self)
	playdate.display.setScale(1)  -- Reset the scale when exiting
end

-- This is called before the system pauses the game
function Play:pause()
    Play.super.pause(self)

	-- Draw the number of collected items to the menu image
    local _img = gfx.image.new(400, 240, gfx.kColorWhite)
    gfx.pushContext(_img)
		gfx.drawTextAligned("*Collected*", 100, 110, kTextAlignment.center)
		gfx.drawTextAligned(collected, 100, 130, kTextAlignment.center)
    gfx.popContext()
    pd.setMenuImage(_img)
end
