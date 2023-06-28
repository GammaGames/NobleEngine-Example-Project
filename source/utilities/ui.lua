-- https://gist.github.com/GammaGames/17e0c64e932e6a5b10919af380276fb1
local pd <const> = playdate
local gfx <const> = Graphics

local box = playout.box.new
local text = playout.text.new

local window = {
    padding = 8,
    border = 2,
    borderRadius = 1,
    minWidth=160,
    maxWidth=210,
    backgroundColor = gfx.kColorWhite,
    font = Noble.Text.FONT_NEWSLEAK
}
local label = {
    padding = 4
}
local labelText = {
    alignment = kTextAlignment.left
}
local input = {
    padding = 4,
    paddingLeft = 8,
    borderRadius = 2,
    border = 1,
    minWidth = 140,
    hAlign = playout.kAlignStart
}
local inputText = {
    alignment = kTextAlignment.left,
    wrap = false
}
local button = {
    padding = 4,
    paddingLeft = 8
}
local buttonHover = {
    padding = 4,
    paddingLeft = 8,
    borderRadius = 2,
    border = 2,
    backgroundColor = gfx.kColorWhite,
    font = Noble.Text.FONT_NEWSLEAK_BOLD,
}

function notify(_text, callback)
    local tree = playout.tree.new(
        box({
            direction = playout.kDirectionVertical,
            spacing = 4,
            style = window,
        }, {
            text(_text, labelText),
            box({ style = button, tabIndex = 1 }, { text("Okay") }),
        })
    )
    tree:computeTabIndex()
    local nodes = tree.tabIndex

    local selectedIndex = 1
    nodes[selectedIndex].style = buttonHover

    pd.inputHandlers.push({
        AButtonDown = function()
            pd.inputHandlers.pop()
            callback()
        end,
        BButtonDown = function()
            pd.inputHandlers.pop()
            callback()
        end,
    }, true)

    return tree:asSprite()
end

function confirm(_text, callback)
    local tree = playout.tree.new(
        box({
            direction = playout.kDirectionVertical,
            spacing = 4,
            style = window
        }, {
            box({ style = label}, { text(_text, labelText) }),
            box({
                direction = playout.kDirectionHorizontal,
                spacing = 8
            }, {
                box({ style = button, tabIndex = 1 }, { text("No") }),
                box({ style = button, tabIndex = 2 }, { text("Yes") }),
            })
        })
    )
    tree:computeTabIndex()
    local nodes = tree.tabIndex

    local selectedIndex = 1
    nodes[selectedIndex].style = buttonHover

    pd.inputHandlers.push({
        leftButtonDown = function()
            nodes[selectedIndex].style = button
            selectedIndex = math.ringInt(selectedIndex - 1, 1, #nodes)
            nodes[selectedIndex].style = buttonHover
            tree:draw()
        end,
        rightButtonDown = function()
            nodes[selectedIndex].style = button
            selectedIndex = math.ringInt(selectedIndex + 1, 1, #nodes)
            nodes[selectedIndex].style = buttonHover
            tree:draw()
        end,
        AButtonUp = function()
            pd.inputHandlers.pop()
            callback(selectedIndex == 2)
        end,
        BButtonUp = function()
            pd.inputHandlers.pop()
            callback(false)
        end,
    }, true)

    return tree:asSprite()
end

function prompt(_text, value, callback)
    local tree = playout.tree.new(
        box({
            direction = playout.kDirectionVertical,
            style = window,
            spacing = 4,
            hAlign = playout.kAlignStart
        }, {
            box({ style = label }, { text(_text, labelText) }),
            box({ style = input, tabIndex = 1 }, { text(value, inputText)}),
        })
    )
    tree:computeTabIndex()
    local nodes = tree.tabIndex
    local input = nodes[1].children[1]

    pd.keyboard.show(value)
    function pd.keyboard.textChangedCallback()
        input.text = pd.keyboard.text
        tree:layout()
        tree:draw()
    end
    function pd.keyboard.keyboardWillHideCallback(ok) callback(ok, pd.keyboard.text) end

    return tree:asSprite()
end
