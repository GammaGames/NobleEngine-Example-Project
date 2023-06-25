local pd <const> = playdate
local gfx <const> = Graphics

BaseScene = {}
class("BaseScene").extends(NobleScene)

BaseScene.backgroundColor = Graphics.kColorWhite

function BaseScene:init()
    BaseScene.super.init(self)

    pd.resetElapsedTime()
    self.menu = pd.getSystemMenu()
end

function BaseScene:update()
    BaseScene.super.update(self)

    Particles:update()
end

function BaseScene:exit()
    BaseScene.super.exit(self)
    self.menu:removeAllMenuItems()
    pd.setMenuImage(nil)
end

function BaseScene:drawBackground()
	BaseScene.super.drawBackground(self)

    if self.background ~= nil then
        self.background:draw(0, 0)
    end
end
