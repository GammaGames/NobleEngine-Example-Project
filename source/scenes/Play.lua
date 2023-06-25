local pd <const> = playdate
local gfx <const> = Graphics

Play = {}
class("Play").extends(BaseScene)

Noble.showFPS = true

local items
local itemTimer
local player
local playerSlot
local ground = gfx.image.new("/assets/images/ground")

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

	self:addSprite(player)
	player:setState("idle")
	playdate.display.setScale(2)
end

-- This runs once a transition from another scene is complete.
function Play:start()
    Play.super.start(self)

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
function Play:update()
	Play.super.update(self)
	-- Your code here
end

function Play:drawBackground()
	Play.super.drawBackground(self)
    -- Your code here
    ground:draw(4, 104)
end

-- This runs as as soon as a transition to another scene begins.
function Play:exit()
    Play.super.exit(self)

	itemTimer:remove()
	Signal:remove("collected")
	printTable(items)
	Noble.GameData.set("items", items, playerSlot)
end

-- This runs once a transition to another scene completes.
function Play:finish()
	Play.super.finish(self)
	-- Your code here
	playdate.display.setScale(1)
end

function Play:pause()
    Play.super.pause(self)
    -- Your code here
end

function Play:resume()
	Play.super.resume(self)
	-- Your code here
end
