function precache_weapons()
	--[[
	game:precachemodel("weapon_ak12")
	game:precachemodel("weapon_ameli")
	game:precachemodel("weapon_arx_160")
	game:precachemodel("weapon_cz_805_bren")
	game:precachemodel("weapon_cbj_ms_iw6")
	game:precachemodel("weapon_fad_iw6")
	game:precachemodel("weapon_riot_gold")
	game:precachemodel("weapon_dragunov_svu")
	game:precachemodel("weapon_p226")
	game:precachemodel("weapon_l115a3")
	game:precachemodel("weapon_l115a3_camo")
	game:precachemodel("weapon_l115a3_gold")
	]]--
	game:precachemodel("weapon_c4_iw6")
	game:precachemodel("weapon_riot_shield_iw6")
	game:precachemodel("weapon_k7")
	
end

function precache_models()
	--[[
	check loaded fastfiles:
	mp_body_udt_smg_f_tr
	mp_head_spectrum_aa_tr
	mp_head_c_helmet_p_tr

	then precache related bodies
	mp_body_udt_smg_f_urban
	mp_body_udt_smg_f_woodland
	head_mp_spectrum_aa
	head_mp_head_c_helmet_p_alt
	]]--
	game:precachemodel("head_mp_merrick_a")
	game:precachemodel("mp_body_mp_merrick_a_elite")
	game:precachemodel("mp_body_mp_merrick_a_urban")
end

function precache_animations()
	-- death animations
	--[[
	game:precachempanim("pb_stand_death_legs")
	game:precachempanim("pb_stand_death_lowerback")
	game:precachempanim("pb_stand_death_head_collapse")
	game:precachempanim("pb_stand_death_neckdeath_thrash") -- nice
	game:precachempanim("pb_stand_death_neckdeath")
	game:precachempanim("pb_stand_death_nervedeath")
	game:precachempanim("pb_stand_death_frontspin")
	game:precachempanim("pb_stand_death_headchest_topple")
	game:precachempanim("pb_stand_death_chest_blowback")
	game:precachempanim("pb_stand_death_chest_spin") -- nice
	game:precachempanim("pb_stand_death_shoulder_stumble")
	game:precachempanim("pb_stand_death_head_straight_back") -- nice
	game:precachempanim("pb_stand_death_tumbleback")
	game:precachempanim("pb_stand_death_kickup")
	game:precachempanim("pb_stand_death_stumbleforward")
	game:precachempanim("pb_stand_death_leg")
	game:precachempanim("pb_stand_death_leg_kickup")
	game:precachempanim("pb_stand_death_headshot_slowfall")
	game:precachempanim("pb_stand_death_shoulderback") -- nice
	game:precachempanim("pb_death_run_forward_crumple")
	game:precachempanim("pb_death_run_onfront")
	game:precachempanim("pb_explosion_death_F1")
	game:precachempanim("pb_crouch_death_headshot_front")
	game:precachempanim("pb_crouch_death_clutchchest")
	game:precachempanim("pb_crouch_death_flip")
	game:precachempanim("pb_crouch_death_fetal")
	game:precachempanim("pb_crouch_death_falltohands")
	game:precachempanim("pb_crouchrun_death_drop")
	game:precachempanim("pb_crouchrun_death_crumple")
	--]]
	-- idle animations
	game:precachempanim("mp_stand_idle")
	-- sprint animations
	--[[
	game:precachempanim("pb_sprint_hold")
	game:precachempanim("pb_sprint_lmg")
	game:precachempanim("pb_sprint_smg")
	game:precachempanim("pb_sprint_assault")
	game:precachempanim("pb_sprint_sniper")
	game:precachempanim("pb_sprint_shotgun")
	game:precachempanim("pb_stand_shoot_walk_forward")
	game:precachempanim("pb_combatrun_forward_loop_sniper")
	-- shoot/aim
	
	game:precachempanim("pb_stand_ads")
	game:precachempanim("pt_stand_shoot")
	game:precachempanim("pt_rifle_fire")
	game:precachempanim("mp_stand_flash_reaction")
	game:precachempanim("mp_stand_flash_reaction_b")
	game:precachempanim("mp_core_stand_fire_ADS")
	game:precachempanim("mp_stand_aim_1")
	game:precachempanim("mp_stand_aim_2")
	game:precachempanim("mp_stand_aim_3")
	game:precachempanim("mp_stand_aim_4")
	game:precachempanim("mp_stand_aim_5")
	game:precachempanim("mp_stand_aim_6")
	game:precachempanim("mp_stand_aim_7")
	game:precachempanim("mp_stand_aim_8")
	game:precachempanim("mp_stand_aim_9")
	]]--
end

function precache_fx()
	-- effects
	forge_fx["cash"] = game:loadfx("fx/props/cash_player_drop")
	forge_fx["teleport"] = game:loadfx("vfx/gameplay/mp/core/vfx_teleport_player")
	forge_fx["3dping"] = game:loadfx("vfx/gameplay/mp/killstreaks/vfx_3d_world_ping")
	forge_fx["betty"] = game:loadfx("fx/explosions/bouncing_betty_explosion")
	forge_fx["c4blink"] = game:loadfx("fx/misc/light_c4_blink")
	forge_fx["blood1"] = game:loadfx("vfx/gameplay/impacts/flesh/vfx_flesh_hit_body")

end

function precache_materials()
	-- materials
	--game:precacheshader("ui_reticle_standard_04") -- orange circle
	--game:precacheshader("ui_reticle_eotech_01") -- square
	--game:precacheshader("ui_reticle_dlc_28") -- sauron eye
	--game:precacheshader("ui_reticle_acog_03") -- blue circle
	--game:precacheshader("ui_reticle_standard_01") -- green crosshair
	--game:precacheshader("ui_reticle_eotech_default") -- red circle crosshair
	--game:precacheshader("ui_reticle_clan_01") -- blue triangle
	game:precacheshader("ui_reticle_dlc_10") -- blue diamond
	game:precacheshader("white")
end