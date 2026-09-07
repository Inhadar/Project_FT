extends Node

var chunk: = preload("res://For_future/Chunk.tscn")
var world_seed
var half_world_size = 15#*2 half value of the world size
var right_barier_placed = false
var left_barier_placed = false


var left_active_chunk = Vector2.ZERO
var right_active_chunk = Vector2.ZERO
var last_chunk = Vector2()

var chunk_width =4
var chunk_height = 16
var tile_size = 32
var chunk_size = chunk_width*tile_size

var prohibited_index = []

var chunck_load =20
var right = false
var far_from_player = true  

var current_chunks_index = 0
var hill_lenght = 5
var chunk_list = []





func _ready():
	
	Globals.pillar_distance = 0
	Globals.global_pillar = false
	Globals.zombie_count  = 0
	Globals.block_count  = 0
	Globals.dead_zombie = 0
	
	
	
	randomize()
	world_seed = randi()
	
	
	var list_1 = []
	var list_2 = []
	
	var bb= 0		
	for a in range(0,half_world_size):
		for b in range(bb,bb+hill_lenght):
			list_2.append(Vector2(b,-a))
			bb +=1
	for i in range(list_2.size()-1,-1,-1):
		if list_2[i] != Vector2.ZERO:
			var a = list_2[i]
			a.x *=-1
			list_1.append(a)
	chunk_list = list_1+list_2
	
	var chunk_counts = ((half_world_size*hill_lenght)*2)-1
	#print(chunk_counts)
	#print(chunk_list.size())
	if chunk_list.size() == chunk_counts:
		var active_chunk_index = chunk_list.find(last_chunk)#last chunk is spawnpoint
		for i in range(-chunck_load,chunck_load):
			var new_chunk_index  = active_chunk_index+i
			if chunk_list.size() > new_chunk_index+1 and new_chunk_index > -1:
			#if active_chunk_index+i > -1 and active_chunk_index+i < chunk_counts:
				var next_index = chunk_list[new_chunk_index]
				var nc= chunk.instance()
				nc.x_index = next_index.x
				nc.y_index = next_index.y
				nc.global_position = Vector2(next_index.x*chunk_size,next_index.y*tile_size)
				add_child(nc)
				right_active_chunk = chunk_list[new_chunk_index-4]#[round((new_chunk_index)-(new_chunk_index/4))]
				left_active_chunk = chunk_list[-new_chunk_index+2]#[round((-new_chunk_index)+(new_chunk_index/4))]

	#print(right_active_chunk,"/",left_active_chunk)
	#print(hl_right)
	#print(len(get_tree().get_nodes_in_group("Chunk")))

func _process(delta):
	
	
	#print(right_active_chunk,"/",left_active_chunk)
	
	check_chunks()#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	
	#print(len(get_tree().get_nodes_in_group("Chunk")))
	
	$CanvasLayer/Label.text = "FPS: " + str(Engine.get_frames_per_second())
	$CanvasLayer/Label2.text = "Zombie_count: " + str(len(get_tree().get_nodes_in_group("Enemy")))
	
	$CanvasLayer/Label3.text = "Block_count: " + str(len(get_tree().get_nodes_in_group("block"))+len(get_tree().get_nodes_in_group("de_block")))
	$CanvasLayer/Label4.text = "P_Dead_Zombie: " + str(Globals.Pillar_dead_zombie)
	$CanvasLayer/Label5.text = "Current_chunk: " + Globals.current_chunk
	#$CanvasLayer/Label6.text = "Current_center_X: " + str(Globals.current_center_x)



	
func check_chunks():
	
	var chunks = get_tree().get_nodes_in_group("Chunk")
	
	for c in chunks:
		
		if $Player.global_position.x > c.global_position.x and $Player.global_position.x < (c.global_position.x + (tile_size*chunk_width)):
			Globals.current_chunk = c.name
		if $Player.global_position.distance_to(c.global_position)>chunk_size*chunck_load:
			
			if $Player.global_position.x > c.global_position.x:
				c.queue_free()
				Globals.active_chunks.erase(Vector2(c.x_index,c.y_index))
				
				var lci = chunk_list.find(left_active_chunk)
				if c.name == str(last_chunk.x-1) + "_" + str(last_chunk.y-16):
					left_barier_placed = false 
					
				else:
					lci +=1
					#print(lci,"/",chunk_list.size(),": ",chunk_list[lci])
					if lci<chunk_list.size():
						left_active_chunk  = chunk_list[lci]
				
				
			if $Player.global_position.x < c.global_position.x:
				c.queue_free()
				Globals.active_chunks.erase(Vector2(c.x_index,c.y_index))
				#print(str(last_chunk.x+1)+"_"+str(last_chunk.y-16))
				var rci = chunk_list.find(right_active_chunk)
				if c.name == str(last_chunk.x+1)+"_"+str(last_chunk.y-16):
					right_barier_placed = false
					Globals.active_chunks.erase(Vector2(c.x_index,c.y_index))
				else:
					rci -= 1
					if rci >=0:
						right_active_chunk = chunk_list[rci]
			
				
			far_from_player = true
		else:
			far_from_player = false
	
		if Globals.current_chunk != "":
			if Globals.created_chunks[Globals.current_chunk][0] in Globals.active_chunks:
				if $Player.global_position.x > get_node(Globals.current_chunk).center_x:
					right = true
				else:
					right = false
				
	
			if right:

				if Globals.current_chunk == str(right_active_chunk.x)+"_"+str(right_active_chunk.y):
					var active_chunk_index = chunk_list.find(right_active_chunk)
					for i in range(active_chunk_index,active_chunk_index+chunck_load):
						if chunk_list.size()>i:
							var next_index = chunk_list[i]
							if !next_index in Globals.active_chunks:
								var nc  = chunk.instance()
								nc.x_index = next_index.x
								nc.y_index = next_index.y
								nc.global_position = Vector2(next_index.x*chunk_size,next_index.y*tile_size)
								add_child(nc)
								right_active_chunk = chunk_list[i-4]
								if i == chunk_list.size()-1:
									last_chunk = chunk_list[i]
									#print(last_chunk)
						else:
							if right_barier_placed == false:
								var nc  = chunk.instance()
								nc.x_index = last_chunk.x+1
								nc.y_index = last_chunk.y-16
								nc.global_position = Vector2((last_chunk.x+1)*chunk_size,(last_chunk.y-16)*tile_size)
								add_child(nc)
								right_barier_placed = true

		
			else:
				if Globals.current_chunk == str(left_active_chunk.x)+"_"+str(left_active_chunk.y):
					var active_chunk_index = chunk_list.find(left_active_chunk)
					for i in range(active_chunk_index,active_chunk_index-chunck_load,-1):
						if i > -1 and i < chunk_list.size():
							var next_index = chunk_list[i]
							#print(next_index)
							if !next_index in Globals.active_chunks:
								var nc  = chunk.instance()
								nc.x_index = next_index.x
								nc.y_index = next_index.y
								nc.global_position = Vector2(next_index.x*chunk_size,next_index.y*tile_size)
								add_child(nc)
								left_active_chunk = chunk_list[i+4]
								
								if i == 0:
									last_chunk = chunk_list[i]
						else:
							if left_barier_placed == false:
								var nc  = chunk.instance()
								nc.x_index = last_chunk.x-1
								nc.y_index = last_chunk.y-16
								nc.global_position = Vector2((last_chunk.x-1)*chunk_size,(last_chunk.y-16)*tile_size)
								add_child(nc)
								left_barier_placed = true
								
				
					
func Button_pressed(weapon_name):
	Globals.current_weapon = weapon_name


func _on_Button_pressed():
	Globals.active_chunks.clear()
	
	var chunks  = get_tree().get_nodes_in_group("Chunk")
	Globals.build_set.clear()
	for chnk in chunks:
		var current_build_node = chnk.name + "_build"
		
		var node_var = get_node_or_null(current_build_node)
		
		#if !node_var: butun chunklara build elave edirik deye buna ehtiyac olmur
		if chnk.get_node(current_build_node).get_children().size()>0:
			#print(build_base.name)
			for bb in chnk.get_node(current_build_node).get_children():
				var block_size
				if bb.is_in_group("1"):
					block_size =1
				elif bb.is_in_group("2"):
					block_size = 2
			
				var df1 = round((bb.global_position.x - chnk.global_position.x)/tile_size)
				var df2 = round((bb.global_position.y - chnk.global_position.y)/tile_size)
				var bb_index = Vector2(df1,df2) #build block index
				bb.name = str(bb_index)
				if chnk.name in Globals.build_set.keys():
					if block_size in Globals.build_set[chnk.name].keys():
						var data1 = bb_index
						var data2 = bb.health
						
						var data3 = bb.block
						Globals.build_set[chnk.name][block_size][bb.name] = [data1,data2,data3]
					
					else:
						Globals.build_set[chnk.name][block_size] = {}
						var data1 = bb_index
						var data2 = bb.health
						var data3 = bb.block
						Globals.build_set[chnk.name][block_size][bb.name] = []
						Globals.build_set[chnk.name][block_size][bb.name] = [data1,data2,data3]
					
						
				else:
					Globals.build_set[chnk.name] = {}
					Globals.build_set[chnk.name][block_size] = {}
					var data1 = bb_index
					var data2 = bb.health
					var data3 = bb.block
					Globals.build_set[chnk.name][block_size][bb.name] = []
					Globals.build_set[chnk.name][block_size][bb.name] = [data1,data2,data3]
	
	#$Chunk_Base.queue_free()
	#Globals.active_chunk.clear()
		#Globals.chunk_list[c.name] = []
	#	if $Player.global_position.distance_to(c.global_position) < 1000:
	#		var a = c.duplicate()
	#		Globals.chunk_list[c.name] = a
	#	c.Player = null
	get_tree().change_scene("res://Worlds/World.tscn")


func _on_Button_button_down():
	Globals.gui_input = true


func _on_Button_button_up():
	Globals.gui_input = false


func _on_SpawnZombie_pressed():
	pass # Replace with function body.
