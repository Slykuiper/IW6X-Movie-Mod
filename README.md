# IW6x Movie Mod
[![IMAGE ALT TEXT HERE](https://i.ytimg.com/vi/wlj6cDA3dEE/maxresdefault.jpg)](https://www.youtube.com/watch?v=wlj6cDA3dEE)

First off - HUGE thank-you to bradstv for updating this projects with support for newer versions. Support him: https://twitter.com/BradLikesTweets

This is my IW6x Movie Making Mod. Free to download or use code snippets in your own mod, I encourage you to learn and get into coding to have more control over your cinematics (and modding is rewarding). Mod is provided as-is, support won't be provided if you DM or reach out for support. Check out the [IW6X Scripting Guide](https://github.com/XLabsProject/iw6x-client/wiki/Scripting) for a great overview of LUA scripting for IW6x and S1x. List of IW6x functions outlined [here](https://github.com/XLabsProject/iw6x-client/blob/master/src/client/game/scripting/function_tables.cpp)

All cinematics created with this mod are recorded live in-game with FRAPS or OBS.  

# Video Tutorial
For a video guide on how to use my mod, check out my [S1x Movie Making Mod Tutorial](https://www.youtube.com/watch?v=QNIUO-LwKZI&lc=UgyYdxLCI-GT_0tEswR4AaABAg). My IW6x functions the exact same besides some minor differences.

### Installation
Download IW6x at https://xlabs.dev/iw6x_download.  
Download [this mod](https://github.com/Slykuiper/IW6X-Movie-Mod/archive/refs/heads/main.zip) and put the **slymvm** folder in `\[rootfolder]\IW6x\scripts\`. Create the scripts folder if it's missing.

### Reshade
IW6x is confirmed to work with [Reshade 4.9.1](https://reshade.me/downloads/ReShade_Setup_4.9.1.exe). It may not work with other versions. Create a shortcut and launch IW6x that way if you want to use Reshade. Right click on iw6x.exe and create a shortcut, add `-multiplayer` to the target and click Apply. Turn Post Processing Anti-Aliasing to Off in the Advanced Video Settings. **Reshade only works in private match**, any shaders using a depth pass (like Depth of Field) won't work on dedicated servers.

# Commands
This mod has a ton of commands, I'll try and highlight them all but feel free to look at the code to see how they're written in-case I leave out any parameters.

### Default Commands
Useful commands that exist in the game that'll help with movie making.  
Use Shift + tilde to view the extended in-game console.

Command | Usage | Description
------------ | ------------- | -------------  
listassetpool | `listassetpool 35 iw6_` |  Lists loaded in-game assets, can be filtered with keys. `listassetpool 35 iw6_` would return all of the standard nase weapon names.
fast_restart | `fast_restart` | Restarts the game instantly.
god | `god` | Gives you unlimited health.
noclip | `noclip` | Allows you to move freely through objects.
spawnbot | `spawnbot` | Adds bots to your match. `spawnbot` will add one bot. `spawnbot 7` will add 7 bots.
kick | `kick RezTech` | Kicks a bot or player from your match.
give | `give iw5_morsloot9_mp` | Gives you a specified weapon.


### IW6x Movie Mod Commands
By default player health is set to 50 to one-shot kill with snipers.
You can edit the default player health by changing `player_health = 50` in `__init__.lua`  
You can precache effects, models, animations, and materials by adding them in `sly_precache.lua`  

### Players / Bots
Player & Bot names are case sensitive.
Command | Usage | Description
------------ | ------------- | -------------  
sly_player_add `number` |`sly_player_add 4` | Adds designated number of bots to your match.
sly_player_kick `name` | `sly_player_kick RezTech` | Kicks a player from your match. `sly_player_kick all` will kick all players.
sly_player_kill `name` | `sly_player_kill RezTech` | Kills a player. `sly_player_kill all` will kill all players.
sly_player_move `name` | `sly_player_move RezTech` | Moves a player to your location. `sly_player_move all` will move all players to your location.
sly_player_freeze `name` | `sly_player_freeze RezTech` | Freezes a player so they can't move or shoot. `sly_player_freeze all` will freeze all players. This is great when getting cinematics with bots to control if/when you want their AI & pathing to work.
sly_player_unfreeze `name` | `sly_player_unfreeze RezTech` | Unfreezes a player, allowing them to move and shoot. `sly_player_unfreeze all` will unfreeze all players.
sly_player_health `name number`| `sly_player_health RezTech 50` | Set's a player's health. `sly_player_health all 50` will give all players except host the desired health. **Currently not working.**
sly_player_weapon `name weapon_name`| `sly_player_weapon RezTech iw6_k7_mp` | Gives a player a specific weapon. Use listassetpool or sly_function getplayerinfo to grab weapon names
sly_player_clone `name clone_name`| `sly_player_clone RezTech MOD_SUICIDE` | Clone's a player. Using without a second variable (`sly_player_clone RezTech`), a spawn basic clone on the player, good for clearing ragdolls and dead bodies. Using a second variable will trigger a random death animation from an array of specific dead animations. See the table below for a list of useful clone types or check **line 27** of `sly_player.lua` for a full list. I added an optional hit-location argument which may affects how which death animation gets triggered. Usage `sly_player_clone RezTech MOD_IMPACT right_hand`. Check **line 59** of `sly_player.lua` for a full list. 
​ | `sly_player_clone RezTech clear` | Spawns 9 ragdolls on the player. Useful for clearing all ragdolls near players.
​ | `sly_player_clone RezTech MOD_GRENADE` | Spawns a ragdoll with an explosive death animation on the player. Similar to , MOD_PROJECTIVE, MOD_PROJECTIVE_SPLASH, and MOD_EXPLOSIVE.
​ | `sly_player_clone RezTech MOD_SUICIDE` | Spawns a typical death animation on the player.
​ | `sly_player_clone RezTech MOD_HEADSHOT` | Spawns a death animation on the player, occasionally headshot-related.


### Dolly Camera
Basic and advanced usage for linear & bezier dolly cams.
Command | Usage | Description
------------ | ------------- | -------------  
sly_cam_mode `mode` | `sly_cam_mode bezier 5` | Sets the camera mode. Available Camera Modes: `linear, bezier, save, load, path`
* Linear
  * Basic, linear camera movement. Second argument defines speed as seconds between each camera node. 
  * Usage: `sly_cam_mode linear 5` will create a linear movement with 5 seconds between each node.
* Bezier
  * Smooth, bezier camera movement. Second argument defines speed. 
  * Usage: `sly_cam_mode bezier 5`
* Save
  * Exports a camera path to the `\slymvm\campaths\` folder. Great for transitions.
  * Usage: `sly_cam_mode save transitionpath1`
* Load
  * Loads a saved camera path from the `\slymvm\campaths\` folder. 
  * Usage: `sly_cam_mode load transitionpath1`
  * Optional argument to load a camera path an angled offset. Usage: `sly_cam_mode load transitionpath1 45` to load `transitionpath1` with a 45 degree offset. 
* Path
  * Toggles path visibility. 
  * Usage: `sly_cam_mode path` 
* Clear
  * Deletes all camera nodes. 
  * Usage: `sly_cam_mode clear` 


Command | Usage | Description
------------ | ------------- | -------------  
sly_cam_node `number` | `sly_cam_node 1` | Creates a camera node, max 10. 
sly_cam_rotate `degrees` | `sly_cam_rotate 45` | Rotates your z-axis by a specific degree amount.

### Spawning Models & Effects
Command | Usage | Description
------------ | ------------- | -------------  
sly_forge_model `model` | `sly_forge_model defaultactor` | Spawns a model on your location. Use `listassetpool 4` with a key to find desired models. Most models need to be precached, do so in the **precache_models()** function in `sly_precache.lua` 
sly_forge_fx `effect` | `sly_forge_fx blood2` | Spawns an effect in front of you. Use `listassetpool 37` with a key to find desired effects and define them in the **precache_fx()** function in `sly_precache.lua`. Most effects don't work even when precached, I spent hours trying to find a working blood effect but only found one that works on only one map.

### Misc & Util Functions
Random debug or useful functions I made. Changing these would be a great start to tinkering with modding.
Command | Usage | Description
------------ | ------------- | -------------  
sly_function savepos | `sly_function savepos` | Saves your position.
sly_function loadpos | `sly_function loadpos` | Loads your position to the saved location.
sly_function camera | `sly_function camera` | Alternate bind instead of noclip
sly_function timescale | `sly_function timescale` | Useful bind that toggles between timescale 1 and 0.1
sly_timescale `number` | `sly_timescale timescale` | Set the timescale.
sly_function fovscale | `sly_function fovscale` | Useful bind that toggles between multiple fovscale values: `1, 0.3, 0.5, and 0.7` Modify to suit your needs
sly_function get `key` | `sly_function get` | Returns specific player variables. Some keys: `origin, health, team, score, model, angles`
sly_function notify `key` | `sly_function notify beziercalc_finished` | Calls the notify() function with a specific key. Useful for debugging.
sly_function unlink | `sly_function unlink` | Unlinks you from any linked entities. Great if you're stuck in a camera path.
sly_function dropweapon | `sly_function dropweapon` | Drops your current weapon. Great for getting a weapon's pullout animation for clips. 
sly_function icon `material` | `sly_function icon headicon_dead` | Creates a waypoint hud element at your feet with a desired material. 
sly_function vision `vision_name` | `sly_function vision` | Sets the player's vision to a desired vision. Some visions: `default, black_bw, aftermath, end_game, default_night_mp, near_death_mp, coup_sunblind`
sly_function getplayerinfo `player_name` | `sly_function getplayerinfo RezTech` | Returns player info to your external console. Name, location, weapon, etc. Expands on this function to get more information.

### Actors
It's pretty built out for the most part. Unfortunately the [scriptmodelplayanim()](https://github.com/XLabsProject/iw6x-client/issues/444) function isn't currently working so Actors are useless. Here are the commands anyway if it gets fixed again. 
Command | Usage | Description
------------ | ------------- | -------------  
sly_actor_animation # animation | `sly_actor_animation 2 mp_stand_idle` | Calls an animation on an actor. Currently broken since the scriptmodelplayanim() function doesn't work. Animation must be precached.
sly_actor_attach # model tag | `sly_actor_attach 2 weapon_k7 j_gun` | Spawns a model an a specified actor's tag. Model must be precached.
sly_actor_create # | `sly_actor_create 1` | Creates an actor. 
sly_actor_destroy # | `sly_actor_destroy 1` | Destroys an actor.
sly_actor_fx # fx tag | `sly_actor_fx 1 betty tag_origin ` | Spawns an effect on the desired actor's tag.
sly_actor_model # body head | `sly_actor_model 1 mp_body_infected_a head_mp_infected` | Changes the actor's model. Second argument (head) is optional. Models must be precached.
sly_actor_move # speed | `sly_actor_move 1 2` | If nodes are set for the actor, this command will move them across the nodes at a set speed.
sly_actor_node # number | `sly_actor_node 1 1 ` | Sets a node for the actor to travel to. Max 2 nodes.
sly_actor_weapon # gun | `sly_actor_weapon 1 weapon_riot_shield_iw6 ` | Takes a weapon model, must be precached. Use `listassetpool 4 weapon_` to find worldmodels. Kinda broken
