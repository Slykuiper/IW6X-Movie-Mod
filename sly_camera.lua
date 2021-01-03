function setcameramode(player)
	-- Sets camera type
	local getdvarargs = splitStr(game:getdvar("sly_cam_mode"))
	game:setdvar("sly_cam_mode", "linear/bezier/clear/print/path, speed")

	cameramode = getdvarargs[1]
	cameraspeed = tonumber(getdvarargs[2])

	if #getdvarargs == 2 then
		if cameramode == "linear" and camera_node[2] ~= nil then
			player:iclientprintln("Camera Mode set to ^:", cameramode, " ^7Speed: ^:", cameraspeed)
			initcameraflightlinear(player, cameraspeed)
		elseif cameramode == "bezier" and camera_node[2] ~= nil then
			player:iclientprintln("Camera Mode set to ^:", cameramode, " ^7Speed: ^:", cameraspeed)
			initcameraflightbezier(player, cameraspeed)
		elseif cameramode == "path" and camera_node[2] ~= nil then
			showbezierpath(player, getdvarargs[2])
		end
	elseif cameramode == "clear" then
		for i, icon in ipairs(camera_node_icon) do
			icon:destroy()
		end
		for i, model in ipairs(camera_node_model) do
			model:delete()
		end
		for i, node in ipairs(camera_node) do
			node:delete()
		end
		camera_node_last = 0
		player:iclientprintln("Camera Nodes ^:cleared!")
	elseif cameramode == "print" then
		player:iclientprintln("Camera Nodes ^:printed!")
		for i, node in ipairs(camera_node) do
			print("==============================================")
			print("Camera Node:", i)
			print("Camera Node Origin:", node.origin.x, node.origin.y, node.origin.z)
			print("Camera Node Angles:", node.angles.x, node.angles.y, node.angles.z)
		end
		print("==============================================")
	end
end

function setcameranode(player)
	-- Creates a camera node, max 10 nodes
	local nodenum = tonumber(game:getdvar("sly_cam_node"))
	local headpos = player:gettagorigin("j_head")
	game:setdvar("sly_cam_node", "#")

	if nodenum >= 1 and nodenum <= 10 then
		if camera_node[nodenum] ~= nil then
			camera_node_icon[nodenum]:destroy()
			camera_node_model[nodenum]:delete()
			camera_node[nodenum]:delete()
		end
		player:iclientprintln("Camera Node: ^:" .. nodenum)
		camera_node_last = nodenum
		-- create camera node
		camera_node[nodenum] = game:spawn("script_model", player.origin)
		camera_node[nodenum].origin = player.origin
		camera_node[nodenum].angles = player:getangles()
		camera_node[nodenum]:setmodel("tag_origin")
		-- create camera node icon
		camera_node_icon[nodenum] = game:newhudelem()
		camera_node_icon[nodenum].x = headpos.x
		camera_node_icon[nodenum].y = headpos.y
		camera_node_icon[nodenum].z = headpos.z
		camera_node_icon[nodenum]:setmaterial(getwaypointicon(nodenum), 15, 15)
		camera_node_icon[nodenum]:setwaypoint(true)
		-- create camera node model
		camera_node_model[nodenum] = game:spawn("script_model", headpos)
		camera_node_model[nodenum].angles = camera_node[nodenum].angles
		camera_node_model[nodenum]:setmodel("vehicle_drone_backup_buddy_gun")

		local fx = game:spawnfx(forge_fx["3dping"], headpos)
		game:triggerfx(fx)
	elseif nodenum > 10 then
		player:iclientprintln("You can only set 10 nodes.")
	end
end

function setcamerarotation(player)
	-- Sets camera rotation
	local getdvarargs = splitStr(game:getdvar("sly_cam_rotate"))
	game:setdvar("sly_cam_rotate", "#")

	if #getdvarargs == 1 then
		-- rotate z axis
		local playerangles = player:getangles()
		playerangles.z = tonumber(getdvarargs[1])
		player:setangles(playerangles)
	elseif #getdvarargs == 3 then
		-- rotate xyz axis
		player:setangles(vector:new(tonumber(getdvarargs[1]), tonumber(getdvarargs[2]), tonumber(getdvarargs[3])))
	end
end

function initcameraflightlinear(player, speed)
	-- Initialize Linear Camera Flight
	revealnodes(false)

	speed = speed / timescale
	local speedms = math.floor(speed / 0.001)

	savedorigin2 = player.origin
    savedangles2 = player:getangles()
	camera_null.origin = camera_node[1].origin
	camera_null.angles = camera_node[1].angles
	camera_null:enablelinkto()
	player:setorigin(camera_node[1].origin)
	player:setangles(camera_node[1].angles)
	player:playerlinkto(camera_null, "tag_origin", 1, 360, 360, 360, 360, false )
	player:freezecontrols(true)

	player:onnotifyonce("lineartimer_finished", function() game:setdvar("cg_draw2d", 0) game:setdvar("cg_drawgun", 0) movelinear(2) end)
	createcountdown((3 / timescale), "^7Starting in: ^:", "lineartimer_finished", player)

	function movelinear(num)
		function movelinear_callback()
			if num == camera_node_last then
				camera_timer:clear() 
				unlinkplayer(player)
			elseif num < camera_node_last then
				num = num + 1
				camera_null:moveto(camera_node[num].origin, speed, 0, 0)
				camera_null:rotateto(camera_node[num].angles, speed, 0, 0)
			end
		end
		camera_null:moveto(camera_node[num].origin, speed, 0, 0)
		camera_null:rotateto(camera_node[num].angles, speed, 0, 0)
		camera_timer = game:oninterval(movelinear_callback, speedms)
	end
end


function initcameraflightbezier(player, speed)
	-- Initialize Bezier Camera Flight
	revealnodes(false)

	-- define variables
	local speed = speed / timescale
	camera_node_alldist = 0
	
	-- prepare bezier camera
	savedorigin2 = player.origin
    savedangles2 = player:getangles()
	camera_null.origin = camera_node[1].origin
	camera_null.angles = camera_node[1].angles
	camera_null:enablelinkto()
	player:setorigin(camera_node[1].origin)
	player:setangles(camera_node[1].angles)
	player:playerlinkto(camera_null, "tag_origin", 1, 360, 360, 360, 360, false )
	player:freezecontrols(true)

	-- calculate total path distance
	player:onnotifyonce("beziertimer_finished", function() bezier_calc(player) end)
	createcountdown((3 / timescale), "^7Starting in: ^:", "beziertimer_finished", player)

	-- move player along spline
	player:onnotifyonce("beziercalc_finished", function() game:setdvar("cg_draw2d", 0) game:setdvar("cg_drawgun", 0) bezier_move(player, speed) end)
end

function bezier_calc(player)
	local k = 1
	function bezier_calc_loop()
		if k == camera_node_last then
			player:notify("beziercalc_finished")
			bezier_calc_timer:clear()
		elseif k < camera_node_last then
			x = camera_node[k].angles.y
			y = camera_node[k+1].angles.y
			if (y - x >= 180) then
				camera_node[k].angles.y = camera_node[k].angles.y + 360
			elseif (y - x <= -180) then
				camera_node[k+1].angles.y = camera_node[k+1].angles.y + 360
			end
			camera_node_partdist[k] = game:distance(camera_node[k].origin, camera_node[k+1].origin )
			camera_node_angledist[k] = game:distance(camera_node[k].angles, camera_node[k+1].angles)
			camera_node_alldist = camera_node_alldist + camera_node_partdist[k]
			camera_node_alldist = camera_node_alldist + camera_node_angledist[k]
			k = k + 1
		end
	end
	bezier_calc_timer = game:oninterval(bezier_calc_loop, 10)
end

function bezier_move(player, speed)
	local dist = camera_node_alldist
	local mul = speed * 10
	local loopcalc1 = dist * 2
	local loopcalc2 = loopcalc1 / mul
	--print("dist: ", dist)
	--print("mul: ", mul)
	--print("loopcalc2: ", loopcalc2)
	local vect1origin = vector:new(0.0, 0.0, 0.0)
	local vect1angles = vector:new(0.0, 0.0, 0.0)

	local vect2origin = vector:new(0.0, 0.0, 0.0)
	local vect2angles = vector:new(0.0, 0.0, 0.0)

	local val = 0
	local t = 0
	function bezier_move_loop()
		if val >= loopcalc2 then
			unlinkplayer(player)
			bezier_move_timer:clear()
		elseif val < loopcalc2 then
			print("val: ", val)
			print("loopcalc2: ", loopcalc2)
			t = (val*mul)/loopcalc1
			vect1origin = vector:new(0.0, 0.0, 0.0)
			vect1angles = vector:new(0.0, 0.0, 0.0)

			for z=1, camera_node_last do
				vect1origin.x = vect1origin.x + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].origin.x)
				vect1origin.y = vect1origin.y + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].origin.y)
				vect1origin.z = vect1origin.z + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].origin.z)
				vect1angles.x = vect1angles.x + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].angles.x)
				vect1angles.y = vect1angles.y + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].angles.y)
				vect1angles.z = vect1angles.z + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].angles.z)
			end

			vect2origin = vector:new(vect1origin.x, vect1origin.y, vect1origin.z)
			vect2angles = vector:new(vect1angles.x, vect1angles.y, vect1angles.z)
			camera_null:moveto(vect2origin, 0.1, 0, 0)
			camera_null:rotateto(vect2angles, 0.1, 0, 0)
			val = val + 1
		end
	end
	bezier_move_timer = game:oninterval(bezier_move_loop, 10)
end

function unlinkplayer(player)
	game:setdvar("cg_draw2d", 1)
	game:setdvar("cg_drawgun", 1)
	player:unlink()
	player:freezecontrols(false)
	player:setorigin(savedorigin2)
	player:setangles(savedangles2)
	revealnodes(true)
end

function koeff(x,y)
	return (fact(y)/(fact(x)*fact(y-x)))
end

function fact(x)
	c = 1
	if x == 0 then
		return 1
	end
	for i = 1, x do
		c = c * i
	end
	return c
end

function pow2(a,b)
	x = 1
	if b ~=0 then
		for i=1, b do
			x = x * a
		end
	end
	return x
end

function revealnodes(bool)
	if bool == true then
		for i, node in ipairs(camera_node) do
			node:show()
		end
		for i, icon in ipairs(camera_node_icon) do
			icon.alpha = 1.0
		end
		for i, model in ipairs(camera_node_model) do
			model:show()
		end
		for i, icon in ipairs(actor_node_icon) do
			icon.alpha = 1.0
		end
		for i, model in ipairs(camera_node_path_model) do
			model:show()
		end
	else
		for i, node in ipairs(camera_node) do
			node:hide()
		end
		for i, icon in ipairs(camera_node_icon) do
			icon.alpha = 0.0
		end
		for i, model in ipairs(camera_node_model) do
			model:hide()
		end
		for i, icon in ipairs(actor_node_icon) do
			icon.alpha = 0.0
		end
		for i, model in ipairs(camera_node_path_model) do
			model:hide()
		end
	end
end

function showbezierpath(player, arg)
	if arg == "off" then
		for i, model in ipairs(camera_node_path_model) do
			model:delete()
		end
	elseif arg == "on" then
		for i, model in ipairs(camera_node_path_model) do
			model:delete()
		end
		-- define variables
		local speed = 10 / timescale
		camera_node_alldist = 0

		-- calculate total path distance
		bezier_calc2(player)

		-- move player along spline
		player:onnotifyonce("beziercalc_finished2", function() bezier_move2(player, speed) end)
	end
end

function bezier_calc2(player)
	local k = 1
	function bezier_calc_loop2()
		if k == camera_node_last then
			player:notify("beziercalc_finished2")
			bezier_calc_timer2:clear()
		elseif k < camera_node_last then
			x = camera_node[k].angles.y
			y = camera_node[k+1].angles.y
			if (y - x >= 180) then
				camera_node[k].angles.y = camera_node[k].angles.y + 360
			elseif (y - x <= -180) then
				camera_node[k+1].angles.y = camera_node[k+1].angles.y + 360
			end
			camera_node_partdist[k] = game:distance(camera_node[k].origin, camera_node[k+1].origin )
			camera_node_angledist[k] = game:distance(camera_node[k].angles, camera_node[k+1].angles)
			camera_node_alldist = camera_node_alldist + camera_node_partdist[k]
			camera_node_alldist = camera_node_alldist + camera_node_angledist[k]
			k = k + 1
		end
	end
	bezier_calc_timer2 = game:oninterval(bezier_calc_loop2, 10)
end

function bezier_move2(player, speed)
	local dist = camera_node_alldist
	local mul = speed * 10
	local loopcalc1 = dist * 2
	local loopcalc2 = loopcalc1 / mul

	local vect1origin = vector:new(0.0, 0.0, 0.0)
	local vect1angles = vector:new(0.0, 0.0, 0.0)

	local vect2origin = vector:new(0.0, 0.0, 0.0)
	local vect2angles = vector:new(0.0, 0.0, 0.0)

	local val = 0
	local t = 0
	function bezier_move_loop2()
		if val >= loopcalc2 then
			bezier_move_timer2:clear()
		elseif val < loopcalc2 then
			print("val: ", val)
			t = (val*mul)/loopcalc1
			vect1origin = vector:new(0.0, 0.0, 0.0)
			vect1angles = vector:new(0.0, 0.0, 0.0)

			for z=1, camera_node_last do
				vect1origin.x = vect1origin.x + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].origin.x)
				vect1origin.y = vect1origin.y + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].origin.y)
				vect1origin.z = vect1origin.z + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].origin.z)
				vect1angles.x = vect1angles.x + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].angles.x)
				vect1angles.y = vect1angles.y + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].angles.y)
				vect1angles.z = vect1angles.z + (koeff(z-1,camera_node_last-1)*pow2((1-t),camera_node_last-z)*pow2(t,z-1)*camera_node[z].angles.z)
			end

			vect2origin = vector:new(vect1origin.x, vect1origin.y, vect1origin.z)
			vect2angles = vector:new(vect1angles.x, vect1angles.y, vect1angles.z)
			val = val + 1
			camera_node_path_model[val] = game:spawn("script_model", vect2origin)
			camera_node_path_model[val].angles = vect2angles
			camera_node_path_model[val]:setmodel("vehicle_drone_backup_buddy_gun")
		end
	end
	bezier_move_timer2 = game:oninterval(bezier_move_loop2, 10)
end

function getwaypointicon(num)
    local material = nil
    num = tonumber(num)

    if num == 1 then
        material = "blitz_time_01_orng"
    elseif num == 2 then
        material = "blitz_time_02_orng"
    elseif num == 3 then
        material = "blitz_time_03_orng"
    elseif num == 4 then
        material = "blitz_time_04_orng"
    elseif num == 5 then
        material = "blitz_time_05_orng"
    elseif num == 6 then
        material = "blitz_time_06_orng"
    elseif num == 7 then
        material = "blitz_time_07_orng"
    elseif num == 8 then
        material = "blitz_time_08_orng"
    elseif num == 9 then
        material = "blitz_time_09_orng"
    elseif num == 10 then
        material = "blitz_time_10_orng"
    end
    return material
end