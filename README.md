# Noble Engine Example Project

This is a documented example project that shows how to use the Noble Engine, along with a handful of libraries.

![demo](demo.gif)

Libraries included are:

* [AnimatedSprite](https://github.com/Whitebrim/AnimatedSprite): Used for the player
* [pdParticles](https://github.com/PossiblyAxolotl/pdParticles): Used for walking pdParticles
* [Playout](https://github.com/potch/playout) - Used for the information popups in the Stats scene
* [Signal](https://github.com/DidierMalenfant/Signal) - Used to notify the scene when an item is collected

## Notes

* I've created a [base scene](source/scenes/BaseScene.lua) with a some default behavior that makes it easier to interact with the system menu
* The [play scene](source/scenes/Play.lua) uses sprites for the world, and most of the input is handled by the [Player](source/scripts/Player.lua) class
* The [stats scene](source/scenes/Stats.lua) draws the grid in the background so it always shows up behind sprites
* Noble branded assets are taken/modified from the [project template](https://github.com/NobleRobot/NobleEngine-ProjectTemplate)
* Other image assets are from [Kenney](https://www.kenney.nl):
  * [1-Bit Pack](https://kenney.nl/assets/1-bit-pack)
  * [1-Bit Platformer Pack](https://kenney.nl/assets/1-bit-platformer-pack)
