extends Node2D


onready var scene = get_parent()
onready var tile_base = self#get_tree().current_scene
onready var Player = scene.get_node("Player")


var noise = preload("res://For_future/softnoise.gd")
var block = preload("res://For_future/block.tscn")
var decore_block = preload("res://For_future/decore_block.tscn")
var under_block = preload("res://For_future/under_block.tscn")
var pillar = preload("res://areas/Mutant_Pillar.tscn")
var chunk = preload("res://Empty_chunk.tscn")
var build_block_1 = preload("res://For_future/sp_block_1.tscn")
var build_block_2 = preload("res://For_future/sp_block_2.tscn")

var world_depth = 32
var surface_height=20
var chunk_width =0
var chunk_height =0
var now_block

var pillar_number = 0
var dg = 0

var pillar_road = 0
var pillar_distance= 2
var tile_size = 0

var center_x = 0
var x_index = 0
var y_index = 0

var build_settings = []

var y
var pre_y 
var next_y
 

func _ready():
	randomize()
	modulate.b = rand_range(0.5,1)
	modulate.g = rand_range(0.5,1)
	modulate.r = rand_range(0,1)
	var sofnoise = noise.SoftNoise.new(5646565645454234)#scene.world_seed)######!!!!!
	chunk_width = scene.chunk_width
	chunk_height += scene.chunk_height
	tile_size = scene.tile_size
	

	center_x = (global_position.x + (tile_size*chunk_width)/2)
	$Sprite.global_position.x = center_x
	#print(center_x)
	

#	Globals.world_pillars.clear()
	pillar_number = 0

	#randomize()
	#var d=0
	#var c 
	#var f 
	
	$Label.text = name
	#$Label.rect_position.x += (chunk_width * tile_size)/2 - ($Label.rect_size.x/2)
	
	"""
	if global_position.x != 0:
		x_index= global_position.x/(tile_size*chunk_width)
	else:
		x_index = 0
	if global_position.y != 0:
		y_index = -global_position.y/(tile_size*chunk_height)
	else:
		y_index = 0
	"""
		
	
	$Index.text = str(x_index,",",y_index)
	$Index.rect_position.x += (chunk_width * tile_size)/2 - ($Index.rect_size.x/2)
	name = str(x_index) + "_" + str(y_index)

	if !name in Globals.created_chunks.keys():
		Globals.created_chunks[name] = []
		Globals.created_chunks[name].append(Vector2(x_index,y_index))
	Globals.active_chunks.append(Vector2(x_index,y_index))
	#make_empthy_chunk()
	
	#print(Globals.created_chunks)


	#add build nodes for structures
	var build_base = Node2D.new()
	build_base.name = name+"_build"
	var node_var = get_node_or_null(build_base.name)
	add_child(build_base)
	build_base.global_position = global_position
	
	
	
	for x in range(0,chunk_width):
		Globals.pillar_distance +=1
		
		
		var pre_y = floor(sofnoise.openSimplex2D((get_global_transform().origin.x/tile_size + (x-1))*.01,0) * surface_height *.2)
		var y = floor(sofnoise.openSimplex2D((get_global_transform().origin.x/tile_size + x)*.01,0) * surface_height *.2)
		var next_y = floor(sofnoise.openSimplex2D((get_global_transform().origin.x/tile_size + (x+1))*.01,0) * surface_height *.2)
		#print(y)
		#var stone_y = floor(sofnoise.openSimplex2D((get_global_transform().origin.x/32 +x)*0.1,32)*4)
		#var basis_y = floor(sofnoise.openSimplex2D((get_global_transform().origin.x/32 +x)*0.5,32))
		#var pillar_y = floor(sofnoise.openSimplex2D((get_global_transform().origin.x +x)*0.1,32)*surface_height*0.5)

		if y<pre_y and y==next_y:
			new_block(Vector2(x*32,y*32),"level0",Color(1,1,1),"left")
		elif y<next_y and y==pre_y:
			new_block(Vector2(x*32,y*32),"level0",Color(1,1,1),"right")
		else:
			new_block(Vector2(x*32,y*32),"level0",Color(1,1,1),"middle")
			
			
			
		for yy in range(0,chunk_height):
			var color = 1
			#new_block(Vector2(x*32,(y+yy+1)*32),"level0",Color(color,color,color),"middle")
			new_under_block(Vector2(x*32,(y+yy+1)*32),"level0",Color(color,color,color),"middle",true)
			#new_decore_block(Vector2(x*32,(y+yy+1)*32),"level0",Color(color,color,color))
		#if x % 25 ==0 and x > 10 and x < chunk_width - 10:
		if x == 0:
				#print(Globals.pillar_distance)
				if Globals.created_chunks[name].has("pillar"):
					if Globals.created_chunks[name][1] == "pillar":
						var pillar_name = Globals.created_chunks[name][1] +"_"+ name
						var pillar_lvl = Globals.created_chunks[name][2]
						if Globals.pillars_list[pillar_name] == false:
							new_pillar(Vector2(x*32,y*32),pillar_name,pillar_lvl)
						
				else:
					"""
					if !Vector2(x_index,y_index) in scene.prohibited_index:
						if int(x_index)%10 == 0:
							randomize()
							var pillar_name = "pillar"+"_"+ name
							#print(name)
							var pillar_lvl = randi()%3+1
							new_pillar(Vector2(x*32,y*32),pillar_name,pillar_lvl)
							Globals.created_chunks[name].append("pillar")
							Globals.created_chunks[name].append(pillar_lvl)
						else:
							Globals.created_chunks[name].append(null)
							Globals.created_chunks[name].append(null)
					"""
					
					
	if int(x_index) %5 == 0 and x_index !=0:
		set_new_build(1)
	player_build()

func new_block(pos,type,color,side):
	var new_block = block.instance()
	new_block.global_position = (pos)
	pillar_road +=1
	new_block.block_type = type
	new_block.current_side = side
	tile_base.add_child(new_block)
	now_block = new_block
	#print(pillar_road)
	Globals.block_count +=1
	
func new_under_block(pos,type,color,side,ub):
	var new_block = under_block.instance()
	new_block.global_position = (pos)
	pillar_road +=1
	new_block.block_type = type
	new_block.under_block = ub
	tile_base.add_child(new_block)
	now_block = new_block
	Globals.block_count +=1
	
func new_decore_block(pos,type,color):
	var new_block = decore_block.instance()
	new_block.global_position = (pos)
	new_block.block_type = type
	new_block.modulate = color
	#new_block.get_node("Sprite").scale.y = 32
	if new_block.block_type != "infected_dirt":
		pass
		#new_block.scale.y = 100
	tile_base.add_child(new_block)
	#now_block = new_block
	Globals.block_count +=1 
	
func new_pillar(pos,p_name,level):
	var new_pillar = pillar.instance()
	new_pillar.global_position = (pos)
	new_pillar.name = p_name
	new_pillar.pillar_level = level
	pillar_number +=1
	if !p_name in Globals.pillars_list.keys():
		Globals.pillars_list[p_name] = false
	tile_base.add_child(new_pillar)
	#print(pillar_name,new_pillar)
	#if !pillar_name in Globals.pillars_mission.keys():
	#	Globals.pillars_mission[pillar_name] = "comp"
		#print(Globals.pillars_mission)
	#if !pillar_name in Globals.world_pillars.keys():
	#	Globals.world_pillars[pillar_name] = new_pillar


func set_new_build(build_level):
	
	var build_set = Globals.build_set
	#print(build_set.get("1_0"),"/",name)
	var bsp = global_position #build_start_pos
	var build_base = Node2D.new()
	build_base.name = name+"_build"
	add_child(build_base)
	
	
	
	if !name in build_set.keys():
		#floor
		randomize()
		var fp = PaternScript.floor_paterns[randi()%PaternScript.floor_paterns.size()]
		var bp = PaternScript.body_paterns[randi()%PaternScript.body_paterns.size()]
		var rp = PaternScript.roof_paterns[randi()%PaternScript.roof_paterns.size()]
		
		var composite_list = [fp,bp,rp]
		
		for patern in composite_list:
			for i in patern.keys():
				var indexes = patern[i]
				for index in indexes:
					var nbb
					if i ==1:#check and set block size
						nbb = build_block_1.instance()#new build block
						randomize()
						#set block levels
						if build_level == 1:
							nbb.block = nbb.level_1_blocks_1[randi()%nbb.level_1_blocks_1.size()]
					elif i == 2:
						nbb = build_block_2.instance()#new long build block 
						randomize()
						#set block levels
						if build_level == 1:
							nbb.block = nbb.level_1_blocks_2[randi()%nbb.level_1_blocks_2.size()]


					var nbi = index #new block index
					nbb.name = str(index)
					nbb.health = JsonData.item_data[nbb.block]["BlockHealt"]
					
					var nbp = Vector2(bsp.x +(tile_size*(nbi.x-1)),bsp.y + (tile_size*(nbi.y-10))) #new_block_position
					get_node(name+"_build").add_child(nbb)
					nbb.global_position = nbp
					
					if !name in build_set.keys():
						Globals.build_set[name] = {}
						Globals.build_set[name][i]={}
						Globals.build_set[name][i][nbb.name] = [nbi,nbb.health,nbb.block]
					else:
						if !i in Globals.build_set[name].keys():
							Globals.build_set[name][i]={}
							Globals.build_set[name][i][nbb.name] = [nbi,nbb.health,nbb.block]
						else:
							if !nbb.name in Globals.build_set[name][i].keys():
								Globals.build_set[name][i][nbb.name] = [nbi,nbb.health,nbb.block]
			
		"""
		for i in fp.keys():
			var indexes = fp[i]
			for index in indexes:
				var nbb
				if i ==1:#check and set block size
					nbb = build_block_1.instance()#new build block
					randomize()
					#set block levels
					if build_level == 1:
						nbb.block = nbb.level_1_blocks_1[randi()%nbb.level_1_blocks_1.size()]
				elif i == 2:
					nbb = build_block_2.instance()#new long build block 
					randomize()
					#set block levels
					if build_level == 1:
						nbb.block = nbb.level_1_blocks_2[randi()%nbb.level_1_blocks_2.size()]


				var nbi = index #new block index
				nbb.name = str(index)
				nbb.health = 100
				#print(nbi)
				var nbp = Vector2(bsp.x +(tile_size*(nbi.x-1)),bsp.y + (tile_size*(nbi.y-10))) #new_block_position
				get_node(name+"_build").add_child(nbb)
				nbb.global_position = nbp
				print(nbb.name)
				if !name in build_set.keys():
					Globals.build_set[name] = {}
					Globals.build_set[name][i]={}
					Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
				else:
					if !i in Globals.build_set[name].keys():
						Globals.build_set[name][i]={}
						Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
					else:
						Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
					
		
		var bp = PaternScript.body_paterns[randi()%PaternScript.body_paterns.size()]
		
		for i in bp.keys():
			var indexes = bp[i]
			for index in indexes:
				var nbb
				
				if i ==1:#check and set block size
					nbb = build_block_1.instance()#new build block
					randomize()
					#set block levels
					if build_level == 1:
						nbb.block = nbb.level_1_blocks_1[randi()%nbb.level_1_blocks_1.size()]
				elif i == 2:
					nbb = build_block_2.instance()#new long build block 
					randomize()
					#set block levels
					if build_level == 1:
						nbb.block = nbb.level_1_blocks_2[randi()%nbb.level_1_blocks_2.size()]
				
				nbb.name = str(index)
				nbb.health = 100
				var nbi = index #new block index
				
				#print(nbi)
				var nbp = Vector2(bsp.x +(tile_size*(nbi.x-1)),bsp.y + (tile_size*(nbi.y-10))) #new_block_position
				get_node(name+"_build").add_child(nbb)
				nbb.global_position = nbp
				if !name in build_set.keys():
					Globals.build_set[name] = {}
					Globals.build_set[name][i]={}
					Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
				else:
					if !i in Globals.build_set[name].keys():
						Globals.build_set[name][i]={}
						Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
					else:
						Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
					
		
		
		var rp = PaternScript.roof_paterns[randi()%PaternScript.roof_paterns.size()]
		for i in rp.keys():
			var indexes = rp[i]
			for index in indexes:
				var nbb
				
				if i ==1:#check and set block size
					nbb = build_block_1.instance()#new build block
					randomize()
					#set block levels
					if build_level == 1:
						nbb.block = nbb.level_1_blocks_1[randi()%nbb.level_1_blocks_1.size()]
				elif i == 2:
					nbb = build_block_2.instance()#new long build block 
					randomize()
					#set block levels
					if build_level == 1:
						nbb.block = nbb.level_1_blocks_2[randi()%nbb.level_1_blocks_2.size()]
				
				nbb.name = str(index)
				nbb.health = 100
				var nbi = index #new block index
				
				#print(nbi)
				var nbp = Vector2(bsp.x +(tile_size*(nbi.x-1)),bsp.y + (tile_size*(nbi.y-10))) #new_block_position
				get_node(name+"_build").add_child(nbb)
				nbb.global_position = nbp
				if !name in build_set.keys():
					Globals.build_set[name] = {}
					Globals.build_set[name][i]={}
					Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
				else:
					if !i in Globals.build_set[name].keys():
						Globals.build_set[name][i]={}
						Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]
					else:
						Globals.build_set[name][i][nbb.name] = [nbi,100,nbb.block]

		"""
func player_build():
		
	var build_set = Globals.build_set
	var bsp = global_position

	
	if name in build_set.keys():
		var objects_types = build_set[name].keys()
		for i in objects_types:
			var objects = build_set[name][i].keys()
			for obj in objects:
				var obj_var = get_node(name+"_build").get_node_or_null(obj)#bu yaranmis objectlerin
				#yeniden yaranmasinin qarsinin alir.
				if obj_var == null:
					var nbb #new build block
					if i == 1:
						nbb = build_block_1.instance()#new build block
					elif i == 2:
						nbb = build_block_2.instance()#new long build block 
					nbb.name = obj
					var block_index = build_set[name][i][obj][0]
					var new_block_pos = Vector2(bsp.x+(block_index.x*tile_size),bsp.y+((block_index.y-10)*tile_size))
					nbb.health = build_set[name][i][obj][1]
					nbb.block = build_set[name][i][obj][2]
					get_node(name+"_build").add_child(nbb)
					nbb.global_position = new_block_pos
