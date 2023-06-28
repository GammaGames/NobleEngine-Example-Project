local pd <const> = playdate
local gfx <const> = Graphics

Stats = {}
class("Stats").extends(BaseScene)

local items
local grid

local locked_image = gfx.image.new("/assets/images/locked")
local heart_image = gfx.image.new("/assets/images/heart")
local icons_it = gfx.imagetable.new("/assets/images/kenney-icons")
local columns, rows = icons_it:getSize()
local modal, modal_animator
local keyTimer
Stats.inputHandler = {
    upButtonDown = function()
        if keyTimer ~= nil then
            return
        end
		local function timerCallback()
            grid:selectPreviousRow(true)
		end
		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
    end,
    upButtonUp = function()
        if keyTimer == nil then
            return
        end
        keyTimer:remove()
        keyTimer = nil
    end,
    downButtonDown = function()
        if keyTimer ~= nil then
            return
        end
		local function timerCallback()
            grid:selectNextRow(true)
		end
		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
    end,
    downButtonUp = function()
        if keyTimer == nil then
            return
        end
		keyTimer:remove()
        keyTimer = nil
    end,
    leftButtonDown = function()
        if keyTimer ~= nil then
            return
        end
		local function timerCallback()
            grid:selectPreviousColumn(true)
		end
		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
    end,
    leftButtonUp = function()
        if keyTimer == nil then
            return
        end
		keyTimer:remove()
        keyTimer = nil
    end,
    rightButtonDown = function()
        if keyTimer ~= nil then
            return
        end
		local function timerCallback()
            grid:selectNextColumn(true)
		end
		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
    end,
    rightButtonUp = function()
        if keyTimer == nil then
            return
        end
		keyTimer:remove()
        keyTimer = nil
    end,
    AButtonDown = function()
        local _, row, column = grid:getSelection()
        local index = math.floor(columns * (row - 1) + column)
        if index == 1 then
            modal = notify("*HELLO :)\nThanks for checking out the example project!*", function()
                Noble.currentScene():removeSprite(modal)
                modal = nil
            end)
        else
            if items[tostring(index)] == nil then
                return
            end
            local count = items[tostring(index)]
            modal = notify("*#"..index.."*: Collected "..count.." time"..(count > 1 and "s" or ""), function()
                Noble.currentScene():removeSprite(modal)
                modal = nil
            end)
        end
        modal_animator = gfx.animator.new(
            500,
            Geometry.lineSegment.new(
                200, 275,
                200, 120
            ),
            Ease.outBack
        )
        Noble.currentScene():addSprite(modal)
    end
}

function Stats:init()
    Stats.super.init(self)
    items = Noble.GameData.get("items", tonumber(Noble.Settings.get("playerSlot")))
    grid = playdate.ui.gridview.new(32, 32)
    grid:setNumberOfColumns(columns)
    grid:setNumberOfRows(rows)
    grid:setSelection(1, 1, 1)
    grid.changeRowOnColumnWrap = false
    function grid:drawCell(_, row, column, selected, x, y, _, _)
        local index = math.floor(columns * (row - 1) + column)
        local image = items[tostring(index)] == nil and locked_image or icons_it:getImage(index)

        if index == 1 then
            if selected then
                image = heart_image
            else
                return
            end
        end

        if selected then
            image:drawScaled(x, y, 2)
        else
            image:draw(x + 8, y + 8)
        end
    end
    self.menu:addMenuItem("menu", function() Noble.transition(Title) end)
end

function Stats:drawBackground()
    grid:drawInRect(0, 0, 400, 240)
end

function Stats:update()
    if grid.needsDisplay then
        gfx.sprite.redrawBackground()
    end
    if modal ~= nil then
        modal:moveTo(modal_animator:currentValue())
    end
end

-- TODO Show number of items collected total %

-- function Title:pause()
-- 	Title.super.pause(self)
-- 	-- Your code here
-- end
-- function Title:resume()
-- 	Title.super.resume(self)
-- 	-- Your code here
-- end

--
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
--     menu:addItem("Stats", function() Noble.transition(Stats, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL) end)
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
