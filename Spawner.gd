extends Node2D


export var zombie_count = 1
export var spawn_y = 300
export var spawn_x = 1000
export var spawn_time = 5

onready var nzombie = preload("res://Zombie_tscn/Enemy_nzombie.tscn")


onready var Player =get_tree().get_root().get_node("World/Player")
var zombie_type = "nzombie"

var active = false

func _ready():
	#if Globals.mszc != 0:
	#	zombie_count = Globals.mszc
		
	#print("zombie_count: ",zombie_count)
	$Spawn_timer.wait_time = spawn_time

	
	
func spawn(target):
	var random = 0
	randomize()
	random = round(rand_range(0,1))

	var new_zombie  = nzombie.instance()
	if random == 0:
		new_zombie.translate(Vector2(target.global_position.x + spawn_x,target.global_position.y- spawn_y))
	else:
		new_zombie.translate(Vector2(target.global_position.x - spawn_x,target.global_position.y- spawn_y))
	
	get_tree().current_scene.add_child(new_zombie)
	Globals.zombie_count +=1








func check_near_tiles():
	pass
#	var blocks =get_tree().get_nodes_in_group("block")
#	for block in blocks:
#		if Player.global_position.distance(block.global_position)<





func _on_Spawn_timer_timeout():
	if Globals.zombie_count < zombie_count:
		#print(Globals.zombie_count," / ",Globals.mszc)
		spawn(Player)
		pass
	else: $Spawn_timer.stop()
