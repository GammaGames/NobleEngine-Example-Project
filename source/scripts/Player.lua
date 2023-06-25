local pd <const> = playdate
local gfx <const> = Graphics

Player = {}
class("Player").extends(AnimatedSprite)

function Player:init(x, y, playerSlot)
    Player.super.init(self, gfx.imagetable.new("/assets/images/character"))

    local skinOffset = (playerSlot - 1) * 7
    self:addState("idle", 1 + skinOffset, 1 + skinOffset)
    self:addState("left", 2 + skinOffset, 4 + skinOffset, { tickStep = 4, flip = playdate.geometry.kFlippedX })
    self:addState("right", 2 + skinOffset, 4 + skinOffset, { tickStep = 4 })

    self:setGroups(COLLISION_LAYERS.PLAYER)
    self:setCollidesWithGroups(COLLISION_LAYERS.ITEM)
    -- self:getSize() doesn't work until we set the state,
    --     which would draw it to the screen
    self:setCollideRect(0, 0, 16, 16)
    self:moveTo(x, y)
    self.movement_speed = 2
    self.x_velocity, self.y_velocity = 0, 0
end

function Player:setState(state)
    if state == "left" then
        self.x_velocity = -1 * self.movement_speed
    elseif state == "right" then
        self.x_velocity = 1 * self.movement_speed
    else
        self.x_velocity = 0
    end

    self:changeState(state)
end

function Player:update()
    Player.super.update(self)
    if self.x_velocity < 0 and self.x > 9 then
        self:moveBy(self.x_velocity, 0)
    elseif self.x_velocity > 0 and self.x < 191 then
        self:moveBy(self.x_velocity, 0)
    end
end

-- function Bobblehead:init(x, y)
--     Bobblehead.super.init(self, playdate.graphics.imagetable.new("assets/images/DinoSprites/vita"))

--     self.shadow = playdate.graphics.sprite.new(Graphics.image.new("assets/images/DinoSprites/shadow"))
--     self.shadow:setZIndex(9)
--     Noble.currentScene():addSprite(self.shadow)

--     self.start_x, self.start_y = x, y
--     self:setZIndex(10)
--     self:addState("idle", 1, 1, {flip=playdate.geometry.kFlippedX})
--     self:addState("bobble", 2, 4, {tickStep=4, flip=playdate.geometry.kFlippedX})
--     self:playAnimation()

--     self.bobble_timer = Timer.new(1000)
--     self.bobble_timer.discardOnCompletion = false
--     self.bobble_timer.repeats = false
--     self.bobble_timer.timerEndedCallback = function()
--         self:changeState("idle")
--     end

--     Noble.currentScene():addSprite(self)
-- end

-- function Bobblehead:update()
--     Bobblehead.super.update(self)

--     local x_offset, y_offset = Display.getOffset()

--     self:moveTo(self.start_x - x_offset, self.start_y - y_offset)
--     self.shadow:moveTo(self.start_x - x_offset, self.start_y - y_offset + 15)

--     if x_offset ~= 0 and y_offset ~= 0 then
--         self:changeState("bobble")
--         self.bobble_timer:reset()
--         self.bobble_timer:start()
--     end
-- end
