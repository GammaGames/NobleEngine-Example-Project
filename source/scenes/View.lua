local pd <const> = playdate
local gfx <const> = Graphics

View = {}
class("View").extends(BaseScene)

-- Play.inputHandler = {
-- 	leftButtonDown = function()
-- 		local function timerCallback()
-- 		end
-- 		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
--     end,
-- 	leftButtonUp = function()
-- 		keyTimer:remove()
-- 	end,
-- 	rightButtonDown = function()
-- 		local function timerCallback()
-- 		end
-- 		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
--     end,
-- 	rightButtonUp = function()
-- 		keyTimer:remove()
--     end,
-- }

-- -- This runs when your scene's object is created, which is the
-- -- first thing that happens when transitioning away from another scene.
-- function Title:init()
-- 	Title.super.init(self)

--     -- gfx.setFontFamily(Noble.Text.FONT_NEWSLEAK_FAMILY)
-- 	Noble.Text.setFont(Noble.Text.FONT_NEWSLEAK)
--     menu = Noble.Menu.new(
--         true,  -- Activate
--         Noble.Text.ALIGN_CENTER,
--         false,  -- No localization
--         nil,  -- Use default color
--         4, 6  -- Adjust padding
--     )
--     menu:addItem("Play", function() Noble.transition(Play, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL) end)
--     menu:addItem("View", function() Noble.transition(View, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL) end)
-- end

-- -- When transitioning from another scene, this runs as soon as this
-- -- scene needs to be visible (this moment depends on which transition type is used).
-- function Title:enter()
--     Title.super.enter(self)

-- 	self:addSprite(logo)
-- end

-- -- This runs once a transition from another scene is complete.
-- function Title:start()
-- 	Title.super.start(self)
-- 	-- Your code here
-- end

-- -- This runs once per frame.
-- function Title:update()
-- 	Title.super.update(self)
-- 	-- Your code here
--     menu:draw(200, 160)
-- end

-- -- This runs as as soon as a transition to another scene begins.
-- function Title:exit()
-- 	Title.super.exit(self)
-- 	-- Your code here
-- end

-- -- This runs once a transition to another scene completes.
-- function Title:finish()
-- 	Title.super.finish(self)
-- 	-- Your code here
-- end

-- function Title:pause()
-- 	Title.super.pause(self)
-- 	-- Your code here
-- end
-- function Title:resume()
-- 	Title.super.resume(self)
-- 	-- Your code here
-- end
