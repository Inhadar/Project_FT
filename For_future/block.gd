extends StaticBody2D

export var texture_1= preload("res://Tiles/Tiles/1.png")
export var texture_2= preload("res://Tiles/Tiles/2.png")
export var texture_3= preload("res://Tiles/Tiles/3.png")
export var texture_4= preload("res://Tiles/Tiles/4.png")
export var texture_5= preload("res://Tiles/Tiles/5.png")
export var texture_6= preload("res://Tiles/Tiles/6.png")
export var texture_7= preload("res://Tiles/Tiles/7.png")


var texture_list = [texture_1,texture_2,texture_3,texture_4,texture_5,texture_6,texture_7]
var block_list = {"level0":0,"level1":1,"level2":2,"level3":3,"level4":4,"level5":5,"level6":6}
var block_sides = {"left":[0],"middle":[1],"right":[2]}
var block_type= null
var current_side = null

var counter_permission = true
var block_position
var current_pillar

var sprite_change =false

var velocity = Vector2.ZERO
var first_check = false
var under_block = false

func _ready():
	#print(block_sides[current_side][randi()%block_sides[current_side].size()])
	if under_block== false:#bunu sidelarla evez et
		$Sprite.frame = block_sides[current_side][randi()%block_sides[current_side].size()]
	
	var pillars = get_tree().get_nodes_in_group("MPillar")
	for pillar in pillars:
		if global_position.distance_to(pillar.global_position) < pillar.max_infection:
			infected(pillar.pillar_level)
			first_check = true
			break
	
	
	
	if first_check ==  false:
		if block_list != null and block_type != null:
			$Sprite.texture=texture_list[block_list[block_type]]
	block_position =global_position
	

	var _useless_value1 = $VisibilityNotifier2D.connect("screen_entered",self,"show")
	var _useless_value2 = $VisibilityNotifier2D.connect("screen_exited",self,"hide")
	visible = false
	set_physics_process(false)

func show():
	visible  = true
	set_physics_process(true)
	#print("show")
func hide():
	visible = false
	set_physics_process(false)
	#print("hide")
func _physics_process(_delta):
	pass
	"""
	#	if $Sprite.frame != block_library[block_list][block_type]:
	#		randomize()
	#		var random_time = rand_range(5,15)
	#		one_timer(random_time)
		
		
	if Globals.block_chunk_update:
		var a = 0
		var pillars = get_tree().get_nodes_in_group("MPillar")
		for pillar in pillars:
			a +=1
			if global_position.distance_to(pillar.global_position) < 300:
				if $Sprite.frame != 4:
					$Sprite.frame = 4
			else:
				randomize()
				var random_time = rand_range(5,15)
				one_timer(random_time)
			if a == pillars.size():
				Globals.block_chunk_update = false
	"""
func one_timer(wait_time):
	var new_timer = Timer.new()
	new_timer.one_shot = false
	new_timer.autostart = false
	new_timer.wait_time =wait_time
	add_child(new_timer)
	new_timer.connect("timeout",self,"One_Timeout")
	new_timer.start()
	

func normal():
	block_type = "level0"
	if $Sprite.texture!=texture_list[block_list[block_type]]:
		$Sprite.texture=texture_list[block_list[block_type]]
		
func infected(level):
	block_type = "level"+str(level)
	if $Sprite.texture!=texture_list[block_list[block_type]]:
		$Sprite.texture=texture_list[block_list[block_type]]

func One_Timeout():
	normal()
