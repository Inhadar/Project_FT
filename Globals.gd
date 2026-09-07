extends Node


var gui_input = false
var camera = null


var current_weapon = "None"#"Pistol"
var pillars_list = {}
var pillars_count = 0
var c_p = false
var block_chunk_update = true
var decore_chunk_update = true

var zombie_count = 0
var dead_zombie = 0
var Pillar_dead_zombie = 0
var mszc = 0
var block_count = 0


var global_pillar = true


#Chunk variables

var current_chunk = ""
var created_chunks = {}
var active_chunks = []
var current_center_x = 0
var world_chunk_size = 8


#Distances
var pillar_distance = 0


#Dust settings
var dust_color_list = {"level0":Color(0.909804, 0.756863, 0.439216,1),"level1":Color(0.25098, 0.890196, 0.545098,1),"level2":Color(0.607843, 0.890196, 0.25098,1),"level3":Color(0.756863, 0.25098, 0.890196,1)}
var dust_color = ""


#build vars
var build_set = {}# store for build data
