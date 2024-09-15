# Noble Engine Example Project

This is a documented example project that shows how to use the Noble Engine, along with a handful of libraries.

![demo](demo.gif)

Libraries included are:

* [AnimatedSprite](https://github.com/Whitebrim/AnimatedSprite): Used for the player
* [pdParticles](https://github.com/PossiblyAxolotl/pdParticles): Used for walking pdParticles
* [Playout](https://github.com/potch/playout) - Used for the information popups in the Stats scene
* [Signal](https://github.com/DidierMalenfant/Signal) - Used to notify the scene when an item is collected

## Notes

* I've created a [base scene](source/scenes/BaseScene.lua) that:
  * Uses the SDK's debug drawing tools, simply add `drawDebug` to your sprites!
  * Callbacks for device sleeping lifecycle
  * A simple event bus for sending messages in the scene
  * A some default behavior that makes it easier to interact with the system menu
  * And probably a few things more!
* The [play scene](source/scenes/Play.lua) uses sprites for the world, and most of the input is handled by the [Player](source/scripts/Player.lua) class
* The [stats scene](source/scenes/Stats.lua) draws the grid in the background so it always shows up behind sprites
* Noble branded assets are taken/modified from the [project template](https://github.com/NobleRobot/NobleEngine-ProjectTemplate)
* Other image assets are from [Kenney](https://www.kenney.nl):
  * [1-Bit Pack](https://kenney.nl/assets/1-bit-pack)
  * [1-Bit Platformer Pack](https://kenney.nl/assets/1-bit-platformer-pack)
* I've also included my [`.vscode`](.vscode) settings, it has a build task that kills the simulator (if running), cleans the build directory, builds the project, zips the build directory, and starts the simulator. It uses the path for the sdk from the [`settings.json`](.vscode/settings.json) file, so you'll need to update that to your own path.
