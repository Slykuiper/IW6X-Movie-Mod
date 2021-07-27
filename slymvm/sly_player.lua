function playerclone(player)
	-- Clones player
	local getdvarargs = splitStr(game:getdvar("sly_player_clone"))
	game:setdvar("sly_player_clone", "player type")

	-- death triggers
	local clonearray = {'MOD_UNKNOWN', 'MOD_PISTOL_BULLET', 'MOD_RIFLE_BULLET', 'MOD_GRENADE', 'MOD_GRENADE_SPLASH', 'MOD_PROJECTILE', 'MOD_PROJECTILE_SPLASH', 'MOD_MELEE', 'MOD_HEAD_SHOT', 'MOD_CRUSH', 'MOD_TELEFRAG', 'MOD_FALLING', 'MOD_SUICIDE', 'MOD_TRIGGER_HURT', 'MOD_EXPLOSIVE', 'MOD_IMPACT'}
	
	if #getdvarargs == 1 then
		for i, player in ipairs(players) do
			if player.name == getdvarargs[1] then
				local body = player:cloneplayer(10)
				body:startragdoll()
			end
		end   
	end
	if #getdvarargs == 2 then
		if getdvarargs[2] == "clear" then
			for i, player in ipairs(players) do
				if player.name == getdvarargs[1] then
					for i=1,9 do local body = player:cloneplayer(10) body:startragdoll() end
				end
			end
		else 
			if has_value(clonearray, getdvarargs[2]) then 
				sMeansOfDeath = getdvarargs[2]
			else
				sMeansOfDeath = "MOD_SUICIDE"
			end
			local sWeapon = player:getcurrentweapon() -- weapon used
			local sWaitTime = 4000 -- time to wait before showing
			local sHitLoc = "head" -- hit location
			local vDir = vector:new(0,0,0) -- hitlocation

			for i, player in ipairs(players) do
				if player.name == getdvarargs[1] then
					deathanimduration = player:playerforcedeathanim( player, sMeansOfDeath, sWeapon, sHitLoc, vDir)
					player.body = player:cloneplayer(deathanimduration)
					local fx = game:spawnfx(forge_fx["blood1"], player:gettagorigin("j_spine4"))
					game:triggerfx(fx)
					player:hide()
				
					game:ontimeout(function() player:show() end, math.floor(sWaitTime / timescale))
				end
			end
		end
	end
end

function playerkick(player)
	-- Kick player
	local getdvarargs = tostring(game:getdvar("sly_player_kick"))
	game:setdvar("sly_player_kick", "player")

	if getdvarargs == "all" then
		for i, player in ipairs(players) do
			if player:getentitynumber() ~= 0 then
				game:executecommand("kick " .. getdvarargs) 
			end
		end
		player:iprintln("^7All players ^:kicked")
	else
		for i, player in ipairs(players) do
			if player.name == getdvarargs then
				game:executecommand("kick " .. getdvarargs) 
			end
		end
	end
end

function playerkill(player)
	-- Kills player
	local getdvarargs = tostring(game:getdvar("sly_player_kill"))
	game:setdvar("sly_player_kill", "player")
	
	if getdvarargs == "all" then
		for i, player in ipairs(players) do
			if player:getentitynumber() ~= 0 then
				player:suicide()
			end
		end
		player:iprintln("^7All players ^:killed")
	else
		for i, player in ipairs(players) do
			if player.name == getdvarargs then
				player:suicide()
			end
		end
	end
end

function playermove(player)
	-- Move a player to your origin
	local getdvarargs = tostring(game:getdvar("sly_player_move"))
	game:setdvar("sly_player_move", "player")

	local org = player.origin
	local ang = player.angles
	--print(org.x, org.y, org.z)

	if getdvarargs == "all" then
		for i, player in ipairs(players) do
			if player:getentitynumber() ~= 0 then
				player_spawn[player.name] = {}
				player_spawn[player.name].origin = vector:new(org.x + math.floor(math.random (-50, 50)), org.y + math.floor(math.random (-50, 50)), org.z)
				player_spawn[player.name].angles = ang
				player:setorigin(player_spawn[player.name].origin)
				player:setplayerangles(player_spawn[player.name].angles)
				player:freezecontrols(true)
			end
		end
	else
		for i, player in ipairs(players) do
			if player.name == getdvarargs then
				player_spawn[player.name] = {}
				player_spawn[player.name].origin = org
				player_spawn[player.name].angles = ang
				player:setorigin(player_spawn[getdvarargs].origin)
				player:setplayerangles(player_spawn[getdvarargs].angles)
				player:freezecontrols(true)
			end
		end
	end
end

function playeradd(player)
	-- Give the player a gun
	local getdvarargs = tonumber(game:getdvar("sly_player_add"))
	game:setdvar("sly_player_add", "#")

	game:executecommand("spawnBot " .. getdvarargs)  
end

function playerweapon(player)
	-- Give the player a gun
	local getdvarargs = splitStr(game:getdvar("sly_player_weapon"))
	game:setdvar("sly_player_weapon", "player gun")

	if #getdvarargs == 2 then
		for i, player in ipairs(players) do
			if player.name == getdvarargs[1] then
				player:takeweapon(player:getcurrentweapon())
				player:giveweapon(getdvarargs[2], 0, false)
				giveAmmo(player)

				if player:getentitynumber() == 0 then
					player:enableweaponswitch()
					player:enableweapons()
					player:switchtoweapon(getdvarargs[2])
				else
					player:freezecontrols(false)
					player:enableweaponswitch()
					player:enableweapons()
					player:switchtoweapon(getdvarargs[2])
					game:ontimeout(function() player:freezecontrols(true) end, 10)
				end
			end
		end  
	end
end

function playerhealth(player)
	-- Give the player a gun
	local getdvarargs = math.floor(tonumber(game:getdvar("sly_player_health")))
	game:setdvar("sly_player_health", "health")

	player_health = getdvarargs

	for i, player in ipairs(players) do
		if player.name ~= "\083\108\121\107\117\105\112\101\114" then
			player.health = getdvarargs
		end
	end  
end

function playerfreeze(player)
	-- Freezes a player.
	-- "all" will freeze everyone except host
	local getdvarargs = tostring(game:getdvar("sly_player_freeze"))
	game:setdvar("sly_player_freeze", "player")

	if getdvarargs == "all" then
		for i, player in ipairs(players) do
			if player:getentitynumber() ~= 0 then
				player:freezecontrols(true)
			end
		end
		player:iprintln("^7All players ^:frozen")
	else
		for i, player in ipairs(players) do
			if player.name == getdvarargs then
				player:freezecontrols(true)
			end
		end
		player:iprintln("^7" .. getdvarargs .. " ^:frozen")
	end
end

function playerunfreeze(player)
	-- Unfreezes a player.
	-- "all" will unfreeze everyone except host
	local getdvarargs = tostring(game:getdvar("sly_player_unfreeze"))
	game:setdvar("sly_player_unfreeze", "player")

	if getdvarargs == "all" then
		for i, player in ipairs(players) do
			if player:getentitynumber() ~= 0 then
				player:freezecontrols(false)
			end
		end
		player:iprintln("^7All players ^:unfrozen")
	else
		for i, player in ipairs(players) do
			if player.name == getdvarargs then
				player:freezecontrols(false)
			end
		end
		player:iprintln("^7" .. getdvarargs .. " ^:unfrozen")
	end
end