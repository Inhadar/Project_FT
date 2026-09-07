extends Node2D


var drop_item = preload("res://Inventory_prototype/Item/DropItem.tscn")

var sp_block3 = preload("res://For_future/block.tscn")
var sp_block1 = preload("res://For_future/sp_block_1.tscn")
var sp_block2 = preload("res://For_future/sp_block_2.tscn")

var block 
var snap_size = 32
var mouse_pos : Vector2 = Vector2.ZERO
var place_p = true

var solid_Area = false

var current_chunk 

var chunk_width =4
var chunk_height = 16
var tile_size = 32
var chunk_size = chunk_width*tile_size


func _ready():
	block = sp_block1


func _physics_process(delta):
	
	
	#print(gui_entered)
	ups()
	if get_tree().root.get_node("/root/World/Player/UI").holding_item == null:
		var current_hotbar_slot
		if PlayerInventory.hotbar.get(PlayerInventory.active_item_slot) != null:
			visible = true
		else:
			visible = false
	cbpa()
	pass
func ups():
	mouse_pos= Vector2(int(get_global_mouse_position().x/snap_size),int(get_global_mouse_position().y/snap_size))
	global_position = mouse_pos *snap_size

func _input(event):
	set_block_and_cursor()#bu buttonla aktivlesecek
	if PlayerInventory.block_place_perm and solid_Area == false and Globals.gui_input == false:
		if get_tree().root.get_node("/root/World/Player/UI").holding_item == null:
			var current_hotbar_slot
			if PlayerInventory.hotbar.get(PlayerInventory.active_item_slot) != null:
				visible = true
				if PlayerInventory.hotbar[PlayerInventory.active_item_slot][1] >1:
					if event.is_action_released("mb_left"):
						current_hotbar_slot = PlayerInventory.hotbar.get(PlayerInventory.active_item_slot)[0]
						var block_size = JsonData.item_data[current_hotbar_slot]["BlockSize"]
						var block_health = JsonData.item_data[current_hotbar_slot]["BlockHealt"]
						if block_size == 1:
							block = sp_block1
						elif block_size ==2:
							block = sp_block2
						var nbins = block.instance()
						PlayerInventory.hotbar[PlayerInventory.active_item_slot][1]-=1
						PlayerInventory.update_hotbar_slot_visual(PlayerInventory.active_item_slot,current_hotbar_slot,PlayerInventory.hotbar[PlayerInventory.active_item_slot][1])
						
						check_current_chunk(nbins,block_health,current_hotbar_slot)

							
						#if current_chunk in Globals.build_set.keys():
						#if block_size in Globals.build_set[current_chunk].keys(): 
						

				
				
				elif PlayerInventory.hotbar[PlayerInventory.active_item_slot][1] == 1:
					if event.is_action_released("mb_left"):
						current_hotbar_slot = PlayerInventory.hotbar.get(PlayerInventory.active_item_slot)[0]
						
						var block_size = JsonData.item_data[current_hotbar_slot]["BlockSize"]
						var block_health = JsonData.item_data[current_hotbar_slot]["BlockHealt"]
						if block_size == 1:
							block = sp_block1
						elif block_size ==2:
							block = sp_block2
						var nbins = block.instance()
						
						PlayerInventory.hotbar[PlayerInventory.active_item_slot][1]-=1
						PlayerInventory.hotbar.erase(PlayerInventory.active_item_slot)
						var slot = get_tree().root.get_node("/root/World/Player/UI/Hotbar/HotbarSlots/slot" +str(PlayerInventory.active_item_slot+1))
						slot.remove_item()
						
						check_current_chunk(nbins,block_health,current_hotbar_slot)

	else:
		if event.is_action_pressed("mb_left"):
			PlayerInventory.block_place_perm = true
func cbpa():
	var up = false
	var down = false
	var right = false
	var left = false
	
	for ray in $cast_base.get_children():
		if ray.name == "up":
			if ray.is_colliding():
				up = true
			else: up = false
		if ray.name == "down":
			if ray.is_colliding():
				down = true
			else: down = false
		if ray.name == "right":
			if ray.is_colliding():
				right = true
			else: right = false
		if ray.name == "left":
			if ray.is_colliding():
				left = true
			else: left = false
		if (up and down) and (left and right):
			if ray.get_collider() is RigidBody2D:
				if Input.is_action_just_pressed("mb_right"):
					ray.get_collider().queue_free()
					var drop_item_instance = drop_item.instance()
					drop_item_instance.item_name = ray.get_collider().block
					drop_item_instance.global_position = global_position
					get_tree().root.get_node("World").add_child(drop_item_instance)
					drop_item_instance.throw()
					var current_block = ray.get_collider()
					
					var ccc = current_block.get_parent().get_parent()  #cursor_current_chunk
					
					
					####Lazimsiz##### REstart edende hersey check olunur onsuz
					"""
					print(ccc.name,"/",current_block.name)
					if current_block.is_in_group("1"):
						if ccc.name in Globals.build_set:
							print(Globals.build_set[ccc.name][1][current_block.name][0])
							Globals.build_set[ccc.name][1].erase(current_block.name)
					elif current_block.is_in_group("2"):
						if ccc.name in Globals.build_set:
							print(Globals.build_set[ccc.name][2][current_block.name][0])
							Globals.build_set[ccc.name][2].erase(current_block.name)
					"""
			#if ray.is_colliding():
			solid_Area = true
		else:solid_Area = false








func set_block_and_cursor():
	if PlayerInventory.hotbar.get(PlayerInventory.active_item_slot) != null:
		var current_hotbar_slot = PlayerInventory.hotbar.get(PlayerInventory.active_item_slot)[0]
		var block_size = JsonData.item_data[current_hotbar_slot]["BlockSize"]
		####Cursor settings#####
		if block_size == 1:
			if  $Sprite.scale.x !=1:
				$Sprite.scale.x = 1
				#block = sp_block1
				for cast in $cast_base.get_children():
					if cast.name =="up":
						cast.global_position.x -= 16
					if cast.name == "down":
						cast.global_position.x -= 16
					if cast.name == "right":
						cast.global_position.x -= 16
						cast.cast_to.y = 21
					if cast.name == "left":
						cast.global_position.x -= 16
						cast.cast_to.y = 21
						
		if block_size == 2:
			if  $Sprite.scale.x != 2:
				$Sprite.scale.x = 2
				#block = sp_block2
				for cast in $cast_base.get_children():
					if cast.name =="up":
						cast.global_position.x += 16
					if cast.name == "down":
						cast.global_position.x += 16
					if cast.name == "right":
						cast.global_position.x += 16
						cast.cast_to.y = 42
					if cast.name == "left":
						cast.global_position.x += 16
						cast.cast_to.y = 42
						











func check_current_chunk(bb,block_health,block_type):

		
	var chunks = get_tree().get_nodes_in_group("Chunk")
	for c in chunks:
		if global_position.x >= c.global_position.x and global_position.x < (c.global_position.x + (tile_size*chunk_width)):
			current_chunk = c
			#print(current_chunk.name)
	#var df1 = ((global_position.x - current_chunk.global_position.x)/tile_size)
	#var df2 =( (global_position.y - current_chunk.global_position.y)/tile_size)
	#var df3 = Vector2(df1,df2)
	#bb.name = str(df3)
	"""
	
	var block_size
	if bb.is_in_group("1"):
		block_size = 1
	elif bb.is_in_group("2"):
		block_size = 2
		
	var df1 = ((global_position.x - current_chunk.global_position.x)/tile_size)
	var df2 =( (global_position.y - current_chunk.global_position.y)/tile_size)
	var df3 = Vector2(df1,df2)
	bb.name = str(df3)
	#print(df3)
	
	
	if current_chunk.name in Globals.build_set.keys():
		if block_size in Globals.build_set[current_chunk.name].keys():
			if !str(df3) in Globals.build_set[current_chunk.name][block_size].keys():
				var data1 = df3
				var data2 = block_health
				var data3 = block_type
				Globals.build_set[current_chunk.name][block_size][str(df3)] = [
					data1,
					data2,
					data3
				]
		else:
			
			Globals.build_set[current_chunk.name][block_size]= {}
			if !str(df3) in Globals.build_set[current_chunk.name][block_size].keys():
				var data1 = df3
				var data2 = block_health
				var data3 = block_type
				Globals.build_set[current_chunk.name][block_size][str(df3)] = [
					data1,
					data2,
					data3
				]
			
			pass
	else:
		Globals.build_set[current_chunk.name] = {}
		Globals.build_set[current_chunk.name][block_size]= {}
		if !str(df3) in Globals.build_set[current_chunk.name][block_size].keys():
			var data1 = df3
			var data2 = block_health
			var data3 = block_type
			Globals.build_set[current_chunk.name][block_size][str(df3)] = [
				data1,
				data2,
				data3
			]
		"""
		
		
	var build_node_name = current_chunk.name + "_build"
	bb.block = block_type
	bb.health = 100
	current_chunk.get_node(build_node_name).add_child(bb)
	bb.global_position = global_position
