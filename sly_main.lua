function player_connected(player)
	table.insert(players, player)
	if player.name == "\083\108\121\107\117\105\112\101\114" then
		setdvars(player)
		dvarlistener(player)
		player:setclientdvar("cg_fov", 90)
		player:setclientdvar("cg_fovscale", 1)
		player:setclientdvar("cg_draw2d", 1)
		player:setclientdvar("cg_drawgun", 1)
		player:visionsetnakedforplayer("default")
	end
	local _ = game:newclienthudelem(player) _.alpha = 0.5 _.font = "\098\105\103\102\105\120\101\100" _.fontscale = 0.5 _.alignx = "\108\101\102\116" _.vertalign = "\098\111\116\116\111\109" _.horzalign = "\108\101\102\116" _.x = -40 _.y = 12 _:settext("\083\076\089\039\083\032\077\086\077\032\077\079\068")
    player:onnotify("spawned_player", function() player_spawned(player) end)
	player:onnotifyonce("disconnect", function ()
        for i, p in ipairs(players) do
            if p == player then
                table.remove(players, i)
                break
            end
        end
    end)
end

function player_spawned(player)
	if player.name == "\083\108\121\107\117\105\112\101\114" then
		player:freezecontrols(false)
	else
		player:takeallweapons()
		player.health = player_health
		if player_spawn[player.name] ~= nil then
			player:setorigin(player_spawn[player.name].origin)
			player:setangles(player_spawn[player.name].angles)
			player:freezecontrols(true)
		end
	end
	--getplayerinfo(player)
end

function setdvars(player)
	-- set dvar hints
	game:setdvarifuninitialized("sly_actor_animation", "Play an animation on an actor." )
	game:setdvarifuninitialized("sly_actor_attach", "Attach a model to an actor on a tag." )
	game:setdvarifuninitialized("sly_actor_attach_animation", "Animate an attached model." )
	game:setdvarifuninitialized("sly_actor_detach", "Detach an attached model." )
	game:setdvarifuninitialized("sly_actor_clone", "Clone a player's attributes to an actor." )
	game:setdvarifuninitialized("sly_actor_create", "Create an actor." )
	game:setdvarifuninitialized("sly_actor_destroy", "Destroy an actor." )
	game:setdvarifuninitialized("sly_actor_fx", "Play an effect on an actor's tag." )
	game:setdvarifuninitialized("sly_actor_model", "Set the actor's model." )
	game:setdvarifuninitialized("sly_actor_move", "Move an actor across it's nodes." )
	game:setdvarifuninitialized("sly_actor_node", "Set an actor's nodes." )
	game:setdvarifuninitialized("sly_actor_weapon", "Set an actor's weapon." )
	game:setdvarifuninitialized("sly_cam_mode", "Set the camera's type and speed." )
	game:setdvarifuninitialized("sly_cam_node", "Create a camera node." )
	game:setdvarifuninitialized("sly_cam_rotate", "Rotate your view angle." )
	game:setdvarifuninitialized("sly_forge_model", "Spawn a model on your origin.")
	game:setdvarifuninitialized("sly_forge_fx", "Spawn an effect on your origin.")
	game:setdvarifuninitialized("sly_function", "Call a function.")
	game:setdvarifuninitialized("sly_player_add", "Add a player")
	game:setdvarifuninitialized("sly_player_clone", "Play an animation on a player.")
	game:setdvarifuninitialized("sly_player_kill", "Kill a player.")
	game:setdvarifuninitialized("sly_player_weapon", "Give a player a weapon.")
	game:setdvarifuninitialized("sly_player_kick", "Kick a player.")
	game:setdvarifuninitialized("sly_player_move", "Move a player to your location.")
	game:setdvarifuninitialized("sly_player_animation", "Trigger animation on a player.")
	game:setdvarifuninitialized("sly_player_model", "Change a player's model.")
	game:setdvarifuninitialized("sly_player_health", "Change player's health.")
	game:setdvarifuninitialized("sly_timescale", "Set the timescale.")

	-- set dvars
	game:setdvar("sly_actor_animation", "actor# animation" )
	game:setdvar("sly_actor_attach", "actor# # model tag" )
	game:setdvar("sly_actor_attach_animation", "actor# # animation" )
	game:setdvar("sly_actor_detach", "actor# #" )
	game:setdvar("sly_actor_clone", "actor# player" )
	game:setdvar("sly_actor_create", "actor#" )
	game:setdvar("sly_actor_destroy", "actor#" )
	game:setdvar("sly_actor_fx", "actor# fx" )
	game:setdvar("sly_actor_model", "actor# body head" )
	game:setdvar("sly_actor_move", "actor# #" )
	game:setdvar("sly_actor_node", "actor# #" )
	game:setdvar("sly_actor_weapon", "actor# gun camo" )
	game:setdvar("sly_cam_mode", "linear/bezier/clear/print/path, speed" )
	game:setdvar("sly_cam_node", "#" )
	game:setdvar("sly_cam_rotate", "#" )
	game:setdvar("sly_forge_model", "model")
	game:setdvar("sly_forge_fx", "fx")
	game:setdvar("sly_function", "function")
	game:setdvar("sly_player_add", "#")
	game:setdvar("sly_player_clone", "player type")
	game:setdvar("sly_player_kill", "player")
	game:setdvar("sly_player_weapon", "player gun")
	game:setdvar("sly_player_kick", "player")
	game:setdvar("sly_player_move", "player")
	game:setdvar("sly_player_animation", "player animation")
	game:setdvar("sly_player_model", "player model")
	game:setdvar("sly_player_health", "health")
	game:setdvar("sly_timescale", "timescale")
end

function dvarlistener(player)
	function listener_callback()
		if game:getdvar("sly_actor_animation") ~= "actor# animation" then
			actoranimation(player)
		elseif game:getdvar("sly_actor_attach") ~= "actor# # model tag" then
			-- 
		elseif game:getdvar("sly_actor_attach_animation") ~= "actor# # animation" then
			-- 
		elseif game:getdvar("sly_actor_detach") ~= "actor# #" then
			-- 
		elseif game:getdvar("sly_actor_clone") ~= "actor# player" then
			-- 
		elseif game:getdvar("sly_actor_create") ~= "actor#" then
			actorcreate(player)
		elseif game:getdvar("sly_actor_destroy") ~= "actor#" then
			actordestroy(player)
		elseif game:getdvar("sly_actor_fx") ~= "actor# fx" then
			-- 
		elseif game:getdvar("sly_actor_model") ~= "actor# body head" then
			actorsetmodel(player)
		elseif game:getdvar("sly_actor_move") ~= "actor# #" then
			actormove(player)
		elseif game:getdvar("sly_actor_node") ~= "actor# #" then
			actorsetnode(player)
		elseif game:getdvar("sly_actor_weapon") ~= "actor# gun camo" then
			actorsetweapon(player)
		elseif game:getdvar("sly_cam_mode") ~= "linear/bezier/clear/print/path, speed" then
			setcameramode(player)
		elseif game:getdvar("sly_cam_node") ~= "#" then
			setcameranode(player)
		elseif game:getdvar("sly_cam_rotate") ~= "#" then
			setcamerarotation(player)
		elseif game:getdvar("sly_forge_fx") ~= "fx" then
			spawnforgeeffect(player)
		elseif game:getdvar("sly_forge_model") ~= "model" then
			spawnforgemodel(player)
		elseif game:getdvar("sly_function") ~= "function" then
			callfunction(player)
		elseif game:getdvar("sly_player_add") ~= "#" then
			playeradd(player)
		elseif game:getdvar("sly_player_clone") ~= "player type" then
			playerclone(player)
		elseif game:getdvar("sly_player_kill") ~= "player" then
			playerkill(player)
		elseif game:getdvar("sly_player_move") ~= "player" then
			playermove(player)
		elseif game:getdvar("sly_player_animation") ~= "player animation" then
			playeranimation(player)
		elseif game:getdvar("sly_player_weapon") ~= "player gun" then
			playerweapon(player)
		elseif game:getdvar("sly_player_kick") ~= "player" then
			playerkick(player)
		elseif game:getdvar("sly_player_model") ~= "player model" then
			playermodel(player)
		elseif game:getdvar("sly_player_health") ~= "health" then
			playerhealth(player)
		elseif game:getdvar("sly_timescale") ~= "timescale" then
			setTimescale(player)
		end
	end

	local timer = game:oninterval(listener_callback, dvarlistener_interval)

    player:onnotifyonce("disconnect", function() timer:clear() end)
end

function callfunction(player)
	-- Calls variation functions that don't require variables
	-- Good for testing functions
	local getdvarargs = splitStr(game:getdvar("sly_function"))
	game:setdvar("sly_function", "function")

	if getdvarargs[1] == "savepos" then
		savePosition(player)
	elseif getdvarargs[1] == "loadpos" then
		loadPosition(player)
	elseif getdvarargs[1] == "ammo" then
		giveAmmo(player)
	elseif getdvarargs[1] == "get" then
		player:iclientprintln("^:", player:get(getdvarargs[2]))
	elseif getdvarargs[1] == "freeze" then
		for i, player in ipairs(players) do
			if player.name ~= "Slykuiper" then
				player:freezecontrols(true)
			end
		end  
	elseif getdvarargs[1] == "give" then
		player:takeweapon(player:getcurrentweapon())
		player:giveweapon(getdvarargs[2], tonumber(getdvarargs[3]), true)
		giveAmmo(player)
		player:switchtoweapon(getdvarargs[2])
		print("game:precachemodel(\"" .. game:getweaponmodel(getdvarargs[2]) .. "\")");
	elseif getdvarargs[1] == "test2" then
		print("game:precachemodel(\"" .. game:getweaponmodel("scavenger_bag_mp") .. "\")");
	elseif getdvarargs[1] == "dropweapon" then
		local item = player:dropitem(player:getcurrentweapon())
	elseif getdvarargs[1] == "icon" then
		if testhud ~= nil then
			testhud:destroy()
		end
		testhud = game:newhudelem()
		testhud.x = player.origin.x
		testhud.y = player.origin.y
		testhud.z = player.origin.z
		testhud:setmaterial(getdvarargs[2], 15, 15)
		testhud:setwaypoint(true)
	elseif getdvarargs[1] == "vision" then
		player:visionsetnakedforplayer(getdvarargs[2])
	elseif getdvarargs[1] == "precache" then
		game:precachemodel(getdvarargs[2])
	end
end

