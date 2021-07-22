--[[
***************************************
General Functions
***************************************
--]]

function splitStr(theString)
 
  stringTable = {}
  local i = 1
 
  -- Cycle through the String and store anything except for spaces
  -- in the table
  for str in string.gmatch(theString, "[^%s]+") do
    stringTable[i] = str
    i = i + 1
  end
 
  -- Return multiple values
  return stringTable, i
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end


--[[
local VectorToString = function(vec)
    return vec.x..' '..vec.y..' '..vec.z
end

local StringToVector = function(str)
        local tab = {}
    for a in string.gmatch(str,"%d+") do
           table.insert(tab,a)
        end
        return Vector3.new(tab[1],tab[2],tab[3])
end
--]]

function vectortostring(vec)
    return vec.x..' '..vec.y..' '..vec.z
end

function dump(value, call_indent)

  if not call_indent then 
    call_indent = ""
  end

  local indent = call_indent .. "  "

  local output = ""

  if type(value) == "table" then
      output = output .. "{"
      local first = true
      for inner_key, inner_value in pairs ( value ) do
        if not first then 
          output = output .. ", "
        else
          first = false
        end
        output = output .. "\n" .. indent
        output = output  .. inner_key .. " = " .. dump ( inner_value, indent ) 
      end
      output = output ..  "\n" .. call_indent .. "}"

  elseif type (value) == "userdata" then
    output = "userdata"
  else 
    output =  value
  end
  return output 
end

function vector_scal(vec, scale)
 	vec.x = vec.x * scale
    vec.y = vec.y * scale
    vec.z = vec.z * scale
 	return vec
end

function getplayerinfo(player)
	-- Prints player information
    print("==============================================")
    print("Player Info: ", player.name)
	--print("Player Origin: ", vectortostring(player.origin))
	--print("Player Angles: ", vectortostring(player.angles))
	print("Player Head: " .. player:getcustomizationhead())
    print("Player Body: " .. player:getcustomizationbody())
	--print("Player Viewhands 1: " .. player:getcustomizationviewmodel())
    print("Player Viewhands: " .. player:getviewmodel())
    --print("Player Weapon: " .. player.primaryweapon)
	print("Player Equipment: " .. player:getcurrentoffhand())
    --print("getweaponarray: " .. player:getweaponarray())
    --print("getweaponattachmentdisplaynames: " .. player:getweaponattachmentdisplaynames(player:getcurrentweapon()))
    --print("getweaponattachments: " .. player:getweaponattachments(player:getcurrentweapon()))
    print("Current Weapon: " .. game:getweapondisplayname(player:getcurrentweapon()) .. " || " .. player:getcurrentweapon() .. " || " .. game:getweaponmodel(player:getcurrentweapon()))
    print("==============================================")
end

--[[
***************************************
TIMERS
USAGE:
    function my_callback()
        player:iprintlnbold("yay!")
    end
    player:onnotify("timer_finished", my_callback)
    createcountup(5, "^7Starting in: ^:", "timer_finished", player)
***************************************
--]]
function createcountdown(max, message, notify, player)
    --local max = max / timescale
    local i = max
    local i_bar = max * 30
    local progressbar_maxwidth = 150
    local progressbar_bg_strokewidth = 2

    if progressbar ~= nil then
        progressbar_text:destroy()
        progressbar_bg:destroy()
		progressbar:destroy()
	end
    progressbar_text = game:newclienthudelem(player)
    progressbar_text.alpha = 1
    progressbar_text.alignx = "center"
	progressbar_text.aligny = "middle"
    progressbar_text.horzalign = "center"
	progressbar_text.vertalign = "middle"
    progressbar_text.x = 0
    progressbar_text.y = -95
	progressbar_text.color = vector:new(1.0, 1.0, 1.0)
    progressbar_text.font = "bigfixed"
    progressbar_text.fontscale = 0.5

    progressbar_bg = game:newclienthudelem(player)
    progressbar_bg.alpha = 1
    progressbar_bg.alignx = "center"
	progressbar_bg.aligny = "middle"
    progressbar_bg.horzalign = "center"
	progressbar_bg.vertalign = "middle"
    progressbar_bg.x = 0
    progressbar_bg.y = -80
	progressbar_bg.color = vector:new(0.0, 0.0, 0.0)
	progressbar_bg:setshader("white", (progressbar_maxwidth + (progressbar_bg_strokewidth * 2)), (10 + (progressbar_bg_strokewidth * 2)))

    progressbar = game:newclienthudelem(player)
    progressbar.alpha = 1
    progressbar.alignx = "center"
	progressbar.aligny = "middle"
    progressbar.horzalign = "center"
	progressbar.vertalign = "middle"
    progressbar.x = 0
    progressbar.y = -80
	progressbar.color = vector:new(0.5, 1.0, 0.5)
	progressbar:setshader("white", progressbar_maxwidth, 10)

	function countdowncreator(max, message, notify)
		if i <= max and i > 0 then
			progressbar_text:settext(message .. tostring(i))
			i = i - 1
		else
			player:notify(notify)
            progressbar_text:destroy()
			countdowntimer:clear()
		end
	end

    function countdownbarcreator(input)
        local progressbar_percent = i_bar / input
        local progressbar_width = progressbar_maxwidth * progressbar_percent
        local progressbar_bg_width = progressbar_width + (progressbar_bg_strokewidth * 2)
        if i_bar <= input and i_bar > 0 then
            progressbar_bg:setshader("white", math.floor(progressbar_bg_width), (10 + (progressbar_bg_strokewidth * 2)))
            progressbar:setshader("white", math.floor(progressbar_width), 10)
			i_bar = i_bar - 1
		else
            progressbar_bg:destroy()
			progressbar:destroy()
            countdownbar:clear()
		end
	end
	countdowntimer = game:oninterval(function() countdowncreator(max, message, notify) end, 1000)
    countdownbar = game:oninterval(function() countdownbarcreator(max*30) end, 33)
    player:onnotifyonce("disconnect", function() countdowntimer:clear() end)
end

function createcountup(max, message, notify, player)
	local i = 1
	function countupcreator(max, message, notify)
		if i <= max then
			player:iprintlnbold(message, i)
			i = i + 1
		else
			player:notify(notify)
			countuptimer:clear()
		end
	end
		
	countuptimer = game:oninterval(function() countupcreator(max, print, notify) end, 1000)
    player:onnotifyonce("disconnect", function() countuptimer:clear() end)
end

function savePosition(player)
	-- Saves player's position
	savedorigin = player.origin
    savedangles = player.angles
	player:iprintln("Position ^:saved.")
end

function loadPosition(player)
	-- Loads player's position
	if savedorigin ~= nil then
		player:setorigin(savedorigin)
		player.angles = savedangles
		player:iprintln("Position ^:loaded.")
	end
end

function giveAmmo(player)
	-- Gives ammo
	player:setweaponammoclip(player:getcurrentweapon(), 9999 )
	player:givemaxammo(player:getcurrentweapon())

	player:setweaponammoclip(player:getcurrentoffhand(), 9999 )
	player:givemaxammo(player:getcurrentoffhand())
end

function setTimescale(player)
	-- Change timescale
	timescale = tonumber(game:getdvar("sly_timescale"))
	game:setdvar("sly_timescale", "timescale")

	player:iprintln("Timescale ^:", timescale)
	game:setslowmotion(timescale, timescale, 0)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function spawndummy(player)
    if dummy ~= nil then
	    dummy:delete()
    end
    dummy = game:spawn("script_model", player.origin)
    dummy.origin = player.origin
    dummy.angles = player.angles
    dummy:setmodel(player:getcustomizationbody())
    dummy:scriptmodelplayanim("mp_stand_idle")
end