json = require("libs.json")
include("sly_main")
include("sly_actor")
include("sly_player")
include("sly_camera")
include("sly_camera_thirdperson")
include("sly_utils")
include("sly_forge")
include("sly_precache")

print("==============================================")
print("Slykuiper's IW6x Movie Making Mod")
print("==============================================")

-- define global variables
players = {}

camera_null = game:spawn("script_model", vector:new(0.0, 0.0, 0.0))
camera_null:setmodel("tag_origin")
camera_node = {}
camera_node_icon = {}
camera_node_model = {}
camera_node_path_model = {}

camera_node_last = 0
camera_node_alldist = 0
camera_node_partdist = {}
camera_node_angledist = {}

camera_base = game:spawn("script_model", vector:new(0.0, 0.0, 0.0))
camera_base:setmodel("test_sphere_silver")
camera_base:enablelinkto()

camera_base_offset = game:spawn("script_model", vector:new(0.0, 0.0, 0.0))
camera_base_offset:setmodel("test_sphere_silver")
camera_base:enablelinkto()

actor = {}
actor_head = {}
actor_node = {}
actor_node_icon = {}
actor_weapon = {}
actor_weapon_attach = {}

forge_num = 0
forge_model = {}
forge_fx = {}

player_health = 50
player_spawn = {}

timescale = 1
dvarlistener_interval = 100

precache_weapons()
precache_playermodels()
precache_playeranimations()
precache_fx()
precache_materials()

level:onnotify("connected", player_connected)
game:setdvar("scr_war_timelimit", 0)
game:setdvar("sv_cheats", 1)
