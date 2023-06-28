import "CoreLibs/easing"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "libraries/noble/Noble"
import "libraries/AnimatedSprite"
import "libraries/pdParticles"
import "libraries/playout"
import "libraries/Signal"

import "utilities/ui"
import "utilities/enum"

import "scripts/Player"
import "scripts/Item"

import "scenes/BaseScene"
import "scenes/Title"
import "scenes/Play"
import "scenes/Stats"

Noble.Text.FONT_NEWSLEAK = Graphics.font.new("assets/fonts/Newsleak Serif/Newsleak-Serif")
Noble.Text.FONT_NEWSLEAK_BOLD = Graphics.font.new("assets/fonts/Newsleak Serif/Newsleak-Serif-Bold")
Noble.Text.FONT_NEWSLEAK_FAMILY = Graphics.font.newFamily({
    [Graphics.font.kVariantNormal] = "assets/fonts/Newsleak Serif/Newsleak-Serif",
    [Graphics.font.kVariantBold] = "assets/fonts/Newsleak Serif/Newsleak-Serif-Bold",
    [Graphics.font.kVariantItalic] = "assets/fonts/Newsleak Serif/Newsleak-Serif"
})

Noble.Settings.setup({
    playerSlot = 1
})
Noble.GameData.setup({
    items = {}
}, 4)
Noble.GameData.saveAll()

COLLISION_LAYERS = enum({
    "PLAYER",
    "ITEM",
})

-- In the future alwaysRedraw will default to false,
--     but for now we need to set it or it will draw every frame
Noble.new(Title, nil, nil, {alwaysRedraw=false})
