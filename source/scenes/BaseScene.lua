local pd <const> = playdate
local gfx <const> = Graphics

BaseScene = {}
class("BaseScene").extends(NobleScene)

BaseScene.backgroundColor = gfx.kColorWhite
BaseScene.debugColor = {1, 0, 0, 1}

function BaseScene:init()
    BaseScene.super.init(self)
    pd.resetElapsedTime()
    self.menu = pd.getSystemMenu()  -- Useful for adding the menu items in your scenes, cleans itself up
    self.debug = false
end

function BaseScene:enter()
    BaseScene.super.enter(self)
    pd.setDebugDrawColor(table.unpack(self.debugColor))
	gfx.sprite.redrawBackground()
    function pd.gameWillTerminate() self:terminate() end  -- Callbacks for fancy close/sleep animations
    function pd.deviceWillSleep() self:sleep() end
    function pd.deviceWillLock() self:lock() end
    function pd.deviceDidUnlock() self:unlock() end
end

function BaseScene:update()
    BaseScene.super.update(self)

    Particles:update()  -- Update our particle library
end

function BaseScene:exit()
    BaseScene.super.exit(self)
    gfx.setDrawOffset(0, 0)

    self.menu:removeAllMenuItems()  -- Remove all custom menu items and reset menu image
    function pd.gameWillTerminate() end
    function pd.deviceWillSleep() end
    function pd.deviceWillLock() end
    function pd.deviceDidUnlock() end
    pd.setMenuImage(nil)
    self:disableDebug()
end

function BaseScene:drawBackground()
    BaseScene.super.drawBackground(self)
    if self.background ~= nil then
        self.background:draw(0, 0) -- Helper so we can just set it to an image
    end
end

function BaseScene:enableDebug()
    self.debug = true
    function pd.debugDraw()
        gfx.pushContext() do
            gfx.setColor(gfx.kColorWhite)
            self:drawDebug()
        end
    end
end

function BaseScene:disableDebug()
    self.debug = false
    function pd.debugDraw() end
end

function BaseScene:drawDebug()
    local sprites = gfx.sprite.getAllSprites()
    for index = 1, #sprites do
        local sprite = sprites[index]
        if sprite.drawDebug ~= nil then
            sprite:drawDebug()
        end
    end
end  -- You can draw stuff to the screen with this
function BaseScene:terminate() end  -- Put animations here (I can show how)
function BaseScene:sleep() end
function BaseScene:lock() end
function BaseScene:unlock() end

-- Added because they're easier to remember and I like using the current scene to communicate
function BaseScene:on(event, callback)
    Signal:add(event, self, callback)
end
function BaseScene:off(event, callback)
    Signal:remove(event, callback)
end
function BaseScene:emit(event, ...)
    Signal:dispatch(event, ...)
end
