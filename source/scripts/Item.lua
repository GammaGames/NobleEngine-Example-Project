local pd <const> = playdate
local gfx <const> = Graphics

Item = {}
class("Item").extends(NobleSprite)

local icons_it = gfx.imagetable.new("assets/images/kenney-icons")

function Item:init(x, y)
    self.it_index = math.random(2, #icons_it)  -- Skip item 1 because it is blank
    Item.super.init(self, icons_it:getImage(self.it_index))

    self.y_velocity = math.random(1, 2)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(COLLISION_LAYERS.ITEM)
    self:setCollidesWithGroups(COLLISION_LAYERS.PLAYER)
    self:add(x, y)
end

function Item:update()
    Item.super.update(self)
    -- if self:collidesWithGroup(COLLISION_LAYERS.PLAYER) then
    --     self:destroy()
    -- end

    local _, _, collisions, length = self:moveWithCollisions(self.x, self.y + self.y_velocity)
    if length > 0 then
        Signal:dispatch("collected", self.it_index)
        self:remove()
    end

    if self.y > 200 then
        self:remove()
    end
end
