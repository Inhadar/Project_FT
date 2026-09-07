extends Area2D

var pillar_level = 0

var mode_list = ["mode_1"]#,"mode_2","mode_3"]
var active = false
var current_mod = 0

var player_in_area = false

var update_permision = true

var decore_block = null


var normal_perms = false


export var max_infection = 600

func _ready():

	#print(Globals.pillars_list)
	#if Globals.pillars_list.get(name) == true:
	#	queue_free()
		
	
	########LEVEL##########
	for lvl_sprite  in $Sprite_container.get_children():
		lvl_sprite.frame = pillar_level
	$Sprite_container/Sprite.scale.x += pillar_level-0.6
	$Sprite_container/Sprite.scale.y += pillar_level
	$Sprite_container/Sprite2.scale = Vector2($Sprite_container/Sprite2.scale.x+pillar_level,$Sprite_container/Sprite2.scale.y+pillar_level)
	$Sprite_container/Sprite2.global_position.y -= (pillar_level-1) * 16
	$Sprite_container/Sprite.global_position.y -= (pillar_level-1) * 16
	
	
	
	
	
	randomize()
	current_mod = mode_list[randi() % mode_list.size()]
	#print("current_mod: ",current_mod)
	
	#if current_mod == "mode_1":
	#	set_mode_1()
		
		
	
	$Level.text = "LEVEL: " + str(pillar_level) 
	$Mode.text = "Mode: " + current_mod
		
		
	if active == true:
		for sprite in $Sprite_container.get_children():
			#sprite.frame = 8
			pass
	else:
		for sprite in $Sprite_container.get_children():
			#sprite.frame = 7
			pass
	var _useless_value1 = $VisibilityNotifier2D.connect("screen_entered",self,"show")
	var _useless_value2 = $VisibilityNotifier2D.connect("screen_exited",self,"hide")
	visible = false
	#set_physics_process(false)

func show():
	visible  = true
	set_physics_process(true)
	#print("show")
func hide():
	visible = false
	set_physics_process(false)
	#print("hide")
	
	
	
func check_near_blocks(max_infection):
	if update_permision:
		var de_blocks = get_tree().get_nodes_in_group("de_block")
		var blocks = get_tree().get_nodes_in_group("block")
		var z = 0
		var x = 0
		if z < de_blocks.size():
			for db in de_blocks:
				z+=1
				if db.global_position.distance_to(global_position) <max_infection:
					if db.block_type != "level" + str(pillar_level):
						db.infected(pillar_level)
				
		if x < blocks.size():
			for b in blocks:
				x +=1
				if b.global_position.distance_to(global_position) < max_infection - 5:
					if b.block_type != "level" + str(pillar_level):
						b.infected(pillar_level)
		update_permision =false###########!!!!!!!!!!!!!
	
	
func normal(max_infection):
	var dblocks = get_tree().get_nodes_in_group("de_block")
	var blocks = get_tree().get_nodes_in_group("block")

	
	for db in dblocks:
		if db.global_position.distance_to(global_position) < max_infection:
			randomize()
			var random_time = rand_range(3,6)
			one_timer(db,random_time)
			
	for b in blocks:
		if b.global_position.distance_to(global_position) < max_infection:
			randomize()
			var random_time = rand_range(1,3)
			one_timer(b,random_time)
	$Spawner.get_node("Spawn_timer").stop()
			





func one_timer(block,wait_time):
	var new_timer = Timer.new()
	new_timer.one_shot =true
	new_timer.wait_time = wait_time
	add_child(new_timer)
	new_timer.connect("timeout",self,"One_TimeOut",[block])
	new_timer.start()
	
	
func One_TimeOut(block):
	if is_instance_valid(block):
		block.normal()
	#print("A")
	

func _physics_process(_delta):

	check_near_blocks(max_infection)
	if active == true:
		if current_mod == "mode_1":
			$Label.text = str(Globals.Pillar_dead_zombie) + " / " + str(Globals.mszc)
		
		#print(Globals.Pillar_dead_zombie,"/",Globals.mszc)
		if Globals.Pillar_dead_zombie >= Globals.mszc:
			$Destroy_timer.start()
			var zombies = get_tree().get_nodes_in_group("zombie")
			for zombie in zombies:
				zombie.queue_free()
			Globals.Pillar_dead_zombie = 0
			visible =false#bu animasiya ile olacaq
			normal(max_infection)
			#print("silindi")
			active = false
			Globals.global_pillar = false
			Globals.pillars_list[name] = true
			print(Globals.pillars_list[name])
	#$Label.text = current_mod#str(Globals.zombie_count) + " / " + str(Globals.mszc)
	#print(Globals.global_pillar,active)

	
	if player_in_area:
		if Input.is_action_just_pressed("E")  and active == false and Globals.global_pillar == false:
			if current_mod == "mode_1":
				
				#stopping spawner when pillar is active
				#get_tree().current_scene.get_node("Spawner/Spawn_timer").stop()
				print("dunya spawner dayandirildi")
				
				var zombies = get_tree().get_nodes_in_group("zombie")
				for zombie in zombies:
					zombie.queue_free()
					Globals.zombie_count -=1
					
				for i in $Sprite_container.get_children():
					i.frame +=1
					set_mode_1()
					$Spawner.get_node("Spawn_timer").start()
					active = true
					Globals.global_pillar = true
					
					
			if current_mod == "mode_2":
				for i in $Sprite_container.get_children():
					i.frame +=2
			if current_mod == "mode_3":
				for i in $Sprite_container.get_children():
					i.frame +=3
	
func set_mode_1():
	randomize()
	 #pillar_level = 0 #round(rand_range(0,3))
	if pillar_level == 1:
		Globals.mszc = round(rand_range(1,2))
		$Spawner.zombie_count = Globals.mszc
		$Spawner.spawn_time = 1
	if pillar_level == 2:
		Globals.mszc = round(rand_range(20,30))
		$Spawner.zombie_count = Globals.mszc
		$Spawner.spawn_time = 0.7
	if pillar_level == 3:
		Globals.mszc = round(rand_range(45,65))
		$Spawner.zombie_count = Globals.mszc
		$Spawner.spawn_time = 0.5
	if pillar_level == 4:
		Globals.mszc = round(rand_range(75,100))
		$Spawner.zombie_count = round(rand_range(75,100))
		$Spawner.spawn_time = 0.3
	#print(Globals.mszc)
		
	#print("pillar_level: ",pillar_level)
		
	$Label.text = str(Globals.zombie_count) + " / " + str(Globals.mszc)


func _on_Mutant_Pillar_body_entered(body):
	if body.name == "Player":
		player_in_area = true


func _on_Mutant_Pillar_body_exited(body):
	if body.name == "Player":
		player_in_area = false


func _on_Destroy_timer_timeout():
	queue_free()
	#get_tree().current_scene.get_node("Spawner/Spawn_timer").start()
	print("Dunya spawner aktivlesdirildi")

