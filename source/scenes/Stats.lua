local pd <const> = playdate
local gfx <const> = Graphics

Stats = {}
class("Stats").extends(BaseScene)

local items
local grid
local modal
local locked_image <const> = gfx.image.new("/assets/images/locked")
local heart_image <const> = gfx.image.new("/assets/images/heart")
local icons_it <const> = gfx.imagetable.new("/assets/images/kenney-icons")
local columns <const>, rows <const> = icons_it:getSize()
local modal_animator = gfx.animator.new(
    500,
    Geometry.lineSegment.new(
        200, 275,
        200, 120
    ),
    Ease.outBack
)
local keyTimer
Stats.inputHandler = {
	BButtonHeld = function()
		Noble.transition(Title)
	end,
    upButtonDown = function()
        -- If there's already a timer, ignore
        if keyTimer ~= nil then
            return
        end
        -- Add repeat timers so users can hold the direction
		local function timerCallback()
            grid:selectPreviousRow(true)
		end
		keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
    end,
    -- Remove the listener on button up
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
        local index = math.floor(columns * (row - 1) + column)  -- Convert row/column to index
        if index == 1 then  -- Index 1 is blank, use a placeholder
            modal = notify("*HELLO :)\nThanks for checking out the example project!*", function()
                Noble.currentScene():removeSprite(modal)
                modal = nil
            end)
        else
            -- If the item is locked, skip
            if items[tostring(index)] == nil then
                return
            end
            -- Else show the status
            local count = items[tostring(index)]
            modal = notify("*#"..index.."*: Collected "..count.." time"..(count > 1 and "s" or ""), function()
                Noble.currentScene():removeSprite(modal)
                modal = nil
            end)
        end
        modal:moveTo(200, 275)  -- Move the modal to the bottom of the screen
        modal_animator:reset()
        Noble.currentScene():addSprite(modal)  -- Add to the current scene
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
    function grid:drawCell(_, row, column, selected, x, y, _, _)  -- Override the drawCell function
        -- Get either the locked image or the unlocked tile image
        local index = math.floor(columns * (row - 1) + column)
        local image = items[tostring(index)] == nil and locked_image or icons_it:getImage(index)

        if index == 1 then  -- Index 1 is blank, use a heart when selected
            if selected then
                image = heart_image
            else
                return
            end
        end

        if selected then
            image:drawScaled(x, y, 2)  -- Draw the sprite larger if selected
        else
            image:draw(x + 8, y + 8)
        end
    end
end

function Stats:start()
    Stats.super.start(self)
    self.menu:addMenuItem("menu", function() Noble.transition(Title) end)
end

-- This will be drawn behind all sprites (the ui popup is a sprite)
function Stats:drawBackground()
    grid:drawInRect(0, 0, 400, 240)
end

function Stats:update()
    if grid.needsDisplay then  -- If the grid changed, redraw background
        gfx.sprite.redrawBackground()
    end
    if modal ~= nil then
        if modal_animator:ended() then  -- Animate the modal
            gfx.sprite.redrawBackground()
        else
            modal:moveTo(modal_animator:currentValue())
        end
    end
end

function Stats:pause()
    Play.super.pause(self)
    local icon_count = (#icons_it - 1)  -- ID 1 is blank
    local item_count = 0
    local collected_count = 0
    for _, count in pairs(items) do
        item_count += 1
        collected_count += count
    end

    local _img = gfx.image.new(400, 240, gfx.kColorWhite)
    gfx.pushContext(_img)
		gfx.drawTextAligned("*Collected*", 100, 90, kTextAlignment.center)
		gfx.drawTextAligned(item_count .. "/" .. icon_count, 100, 110, kTextAlignment.center)
		gfx.drawTextAligned(string.format("%.2f %%", item_count / icon_count * 100), 100, 130, kTextAlignment.center)
		gfx.drawTextAligned(collected_count .. " Collected total", 100, 150, kTextAlignment.center)
        gfx.popContext()
    pd.setMenuImage(_img)
end
