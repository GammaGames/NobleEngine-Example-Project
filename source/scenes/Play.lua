local pd <const> = playdate
local gfx <const> = Graphics

Play = {}
class("Play").extends(BaseScene)

local items
local itemTimer
local player
local playerSlot
local ground = gfx.image.new("/assets/images/ground")
local tree = gfx.image.new("/assets/images/tree")
local grass = gfx.image.new("/assets/images/grass")

Play.inputHandler = {
	leftButtonDown = function()
		player:setState("left")
    end,
	leftButtonUp = function()
		player:setState("idle")
	end,
	rightButtonDown = function()
		player:setState("right")
    end,
	rightButtonUp = function()
		player:setState("idle")
    end,
}

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitioning away from another scene.
function Play:init()
    Play.super.init(self)

	playerSlot = tonumber(Noble.Settings.get("playerSlot"))
	items = Noble.GameData.get("items", playerSlot)
	player = Player(100, 96, playerSlot)
    self.menu:addMenuItem("menu", function() Noble.transition(Title) end)
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function Play:enter()
    Play.super.enter(self)

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
	player:setState("idle")
	playdate.display.setScale(2)
end

-- This runs once a transition from another scene is complete.
function Play:start()
    Play.super.start(self)

	Noble.showFPS = true
	Signal:add("collected", self, function(_, _, value)
		local key = tostring(value)
		if items[key] == nil then
			items[key] = 0
		end
		items[key] += 1
	end)
	itemTimer = Timer.new(1000, function()
		Item(math.random(10, 190), -10)
    end)
	itemTimer.repeats = true
end

-- This runs once per frame.
-- function Play:update()
-- 	Play.super.update(self)
-- 	-- Your code here
-- end

-- function Play:drawBackground()
-- 	Play.super.drawBackground(self)
--     -- Your code here
-- 	tree:draw(24, 80)
-- 	tree:draw(146, 74)
-- 	grass:draw(56, 89, gfx.kImageFlippedX)
-- 	grass:draw(156, 89)
--  ground:draw(4, 104)
-- end

-- This runs as as soon as a transition to another scene begins.
function Play:exit()
    Play.super.exit(self)

	Noble.showFPS = false
	itemTimer:remove()
	Signal:remove("collected")
	Noble.GameData.set("items", items, playerSlot)
end

-- This runs once a transition to another scene completes.
function Play:finish()
	Play.super.finish(self)
	-- Your code here
	playdate.display.setScale(1)
end

-- TODO Show number of items collected
function Play:pause()
    Play.super.pause(self)
    -- Your code here
end

function Play:resume()
	Play.super.resume(self)
	-- Your code here
end
