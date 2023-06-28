local pd <const> = playdate
local gfx <const> = Graphics

BaseScene = {}
class("BaseScene").extends(NobleScene)

function BaseScene:init()
    BaseScene.super.init(self)

    pd.resetElapsedTime()  -- Reset time so each scene starts at 0
    self.menu = pd.getSystemMenu()  -- Store this so we have access to it in all scenes
end

function BaseScene:update()
    BaseScene.super.update(self)

    Particles:update()  -- Update our particle library
end

function BaseScene:exit()
    BaseScene.super.exit(self)
    self.menu:removeAllMenuItems()  -- Remove all custom menu items and reset menu image
    pd.setMenuImage(nil)
end

function BaseScene:drawBackground()
	BaseScene.super.drawBackground(self)

    if self.background ~= nil then  -- Helper so you can set a scene's background to an image
        self.background:draw(0, 0)
    end
end
