local pd <const> = playdate
local gfx <const> = Graphics

Player = {}
class("Player").extends(AnimatedSprite)

function Player:init(x, y, playerSlot)
    Player.super.init(self, gfx.imagetable.new("/assets/images/character"))
    self:remove() -- AnimatedSprite adds itself to the scene, we want to do that through Noble

    local skinOffset = (playerSlot - 1) * 7
    self:addState("idle", 1 + skinOffset, 1 + skinOffset, {}, true)  -- Set as default state
    self:addState("left", 2 + skinOffset, 4 + skinOffset, { tickStep = 4, flip = playdate.geometry.kFlippedX })
    self:addState("right", 2 + skinOffset, 4 + skinOffset, { tickStep = 4 })

    self:setGroups(COLLISION_LAYERS.PLAYER)
    self:setCollidesWithGroups(COLLISION_LAYERS.ITEM)
    self:setCollideRect(0, 0, self:getSize())
    self:moveTo(x, y)
    self.movement_speed = 2
    self.x_velocity = 0
end

function Player:update()
    if not self.active then
        return
    end

    Player.super.update(self)

    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.x_velocity = -1 * self.movement_speed
        self:changeState("left")
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.x_velocity = 1 * self.movement_speed
        self:changeState("right")
    else
        self.x_velocity = 0
        self:changeState("idle")
    end

    if self.x_velocity < 0 and self.x > 9 then
        self:moveBy(self.x_velocity, 0)
    elseif self.x_velocity > 0 and self.x < 191 then
        self:moveBy(self.x_velocity, 0)
    end
end
