extends Node2D

onready var scene = get_tree().current_scene
onready var chunk_base = self
onready var Player = scene.get_node("Player")
var chunk = load("res://For_future/Chunk.tscn")

export var chunk_count=4

var index = Vector2.ZERO
var tile_size = 0
var chunk_h = 0
var chunk_w = 0

var center_x = 0

var right = false

var top_layer
var under_layer

var far_from_player = false


var one_time_perm = false

var children = get_children()
func _ready():
	Globals.build_distance += 1
	
	
	top_layer = "dirt"
	under_layer = "dirt"
	
	#Globals.chunk_count +=1 
	#print(Globals.chunk_count)
	
	chunk_w = scene.chunk_width
	chunk_h = scene.chunk_height
	tile_size = scene.tile_size
	center_x = (global_position.x + (tile_size*chunk_w)/2)
	if global_position.x != 0:
		index.x= global_position.x/(tile_size*chunk_w)
	else:
		index.x = 0
	if global_position.y != 0:
		index.y = -global_position.y/(tile_size*chunk_h)
	else:
		index.y = 0
	"""
	
	for block in get_children():
		if block.is_in_group("block"):
			block.block_list = "world_block_list"
			block.block_type = top_layer
		if block.is_in_group("de_block"):
			block.block_list = "world_block_list"
			block.block_type = under_layer
	"""
	$Name.rect_position.x = (chunk_w * tile_size)/2 - ($Name.rect_size.x/2)
	$Index.rect_position.x = (chunk_w * tile_size)/2 - ($Index.rect_size.x/2)
	$Center_X.rect_position.x = (chunk_w * tile_size)/2 - ($Index.rect_size.x/2)
	
	$Name.text = name
	$Index.text = str(index)
	$Center_X.text = str(center_x)
	
	randomize()
	
	#modulate.r = rand_range(0.6,1)
	#modulate.g = rand_range(0.6,1)
	#modulate.b = rand_range(0.6,1)
	
	one_time_perm = true
	
	
	$VisibilityNotifier2D.global_position.x = center_x
	$VisibilityNotifier2D.scale.x = (tile_size*chunk_w)/20
	$VisibilityNotifier2D.connect("screen_entered",self,"show")
	$VisibilityNotifier2D.connect("screen_exited",self,"hide")
	visible = false
	set_process(false)


func show():
	visible  = true
	set_process(true)
	#print("show")
func hide():
	#if !self in Globals.chunk_list.values():
		#var last_v_chunk = self.duplicate()
		#Globals.chunk_list[name] = last_v_chunk
	queue_free()
	var indx = Globals.created_chunks.find(index)
	Globals.created_chunks.remove(indx)
	#Globals.chunk_count -=1
	visible = false
	set_process(false)
	#print("hide")
	

func _process(_delta:float)->void:
	#print(len(Globals.created_chunks))
	#if Globals.first_load == false and len(Globals.created_chunks) < Globals.world_chunk_size:
		if Player != null:
			var a = Player.global_position.x
			var b = center_x
			if round_to_dec(a/b,1) == 1:
				Globals.current_chunk = name
			
		if global_position.distance_to(Player.global_position) > 2000:
			far_from_player = true
		else:
			far_from_player = false
		
		
		if Globals.current_chunk == name:
			if Player.global_position.x > center_x:
				right = true
				#print("R")
			else:
				right = false
				#print("L")

			if right:
				var usable_index = index
				for i in range(0,chunk_count):
					usable_index = index
					usable_index.x +=i
					var next_index = Vector2(usable_index.x,usable_index.y)
					var next_chunk = str(usable_index.x)+"_"+str(usable_index.y)
					if !next_index in Globals.created_chunks:
						#if !next_index in Globals.index_list.values():
							var new_chunk = chunk.instance()
							new_chunk.global_position = (Vector2(next_index.x*(tile_size*chunk_w),next_index.y*(tile_size*chunk_h)))
							chunk_base.add_child(new_chunk)
							
							
						#else:
						#	load_chunk(next_chunk,next_index)
							#load old chunks
						
			else:
				var usable_index = index
				for i in range(0,chunk_count):
					usable_index = index
					usable_index.x -=i
					var pre_index = Vector2(usable_index.x,usable_index.y)
					var pre_chunk = str(usable_index.x)+"_"+str(usable_index.y)
					if !pre_index in Globals.created_chunks:
					#	if !pre_index in Globals.index_list.values():
							var new_chunk = chunk.instance()
							new_chunk.global_position = (Vector2(pre_index.x*(tile_size*chunk_w),pre_index.y*(tile_size*chunk_h)))
							chunk_base.add_child(new_chunk)
							
					#	else:
					#		load_chunk(pre_chunk,pre_index)
							#load old chunks
						
						
						
						
						
						
						
	
	
	
	
	
		#print(Globals.chunk_count)
	















func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)



#######################################!!!!!!!!!!!!!!!!
func load_chunk(chunk_name,index):
	if is_instance_valid(Globals.chunk_list[chunk_name]):
		var old_chunk = Globals.chunk_list[chunk_name]
		old_chunk.global_position = Vector2(index.x*(tile_size*chunk_w),index.y*(tile_size*chunk_h))
		old_chunk.name = chunk_name
		if !old_chunk.is_inside_tree():
			chunk_base.add_child(old_chunk)
		Globals.created_chunks.append(index)
		#var last_v_chunk = self.duplicate()
		#Globals.chunk_list[name] = last_v_chunk
#######################################!!!!!!!!!!!!!!!!
