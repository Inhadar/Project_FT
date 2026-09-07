extends KinematicBody2D

onready var Player = get_tree().current_scene.get_node("Player")
onready var zombie_part = preload("res://ZP/Zombie_part.tscn")

var velocity = Vector2.ZERO
var speed = 100
var gravity = 10
var direction = 0
var zombie_is_stop = false
var is_on_floor = false
var zsp = false
var stop_from_distance = false
var sleep_ready = false
var sleep = false
var step_perms = false

var full_healt = 100
var healt = 100

var knockhit = 140
var kp = false

var is_dead = false


func _ready():
	var _useless_value1 = $VisibilityNotifier2D.connect("screen_entered",self,"show")
	var _useless_value2 = $VisibilityNotifier2D.connect("screen_exited",self,"hide")
	visible = false

func show():
	speed = 100
	visible  = true
	set_physics_process(true)
	modulate = Color(1,1,1)
func hide():
	speed =  2000
	visible = false
	



func _process(_delta):
	#!!!!! Zombie bezen ilişir
	#if dead == false:
			
	#if zombie_is_stop:
	#	modulate = Color(1, 0.003922, 0.003922)
	#else:modulate = Color(1,1,1)
	
	check_way()
	set_direction()
		#print(zombie_is_stop)
		#if global_position.distance_to(Player.global_position) < 2000 and stop_from_distance:
			#print("zombie uzaqliqdan dayanmagi legv edildi")
			#set_physics_process(true)
		#	stop_from_distance = false
		#if global_position.distance_to(Player.global_position) > 1000 and sleep_ready == false and zombie_is_stop:
		#	$Sleep_Timer.start()
		#	sleep_ready = true
		#	print("zombie yatmaga hazirlandi")
		#elif global_position.distance_to(Player.global_position) < 1000 and sleep_ready == true:
		#	$Sleep_Timer.stop()
		#	sleep_ready = false
		#	sleep = false
		#	print("zombie aniden oyandi")
			
	if global_position.distance_to(Player.global_position) < 2000 and stop_from_distance and zombie_is_stop:
		zombie_is_stop = false
		stop_from_distance = false
		$Destroy_Timer.stop()
		set_physics_process(true)
		#print("zombie yaxinliqdan oyandi")
		
func _physics_process(_delta: float) -> void:
	if is_dead == false:
	
		if !is_on_floor():
			velocity.y += gravity
		
		if kp == true:
			velocity.x  = -direction * knockhit
		else:
			velocity.x = direction * speed
			if step_perms:
				velocity.y = - 150

		if global_position.distance_to(Player.global_position) > 5000:
			zombie_is_stop = true
			stop_from_distance = true
			$Destroy_Timer.start()
			set_physics_process(false)
			#print("zombie uzaqliqdan dayandi")
		#print(global_position.distance_to(Player.global_position))
		velocity =  move_and_slide(velocity,Vector2.UP)
	#if dead == false:
		 
		
	#	if zsp and global_position.distance_to(Player.global_position) > 5000:
	#		set_physics_process(false)
	#		zombie_is_stop = true
	#		#print("zombie uzaqliqdan dayandi")
	#		modulate =Color(1, 0.003922, 0.003922)
	#		zsp = false
	#		stop_from_distance = true
	#	
	#	
	#	if kp == true:
	#		velocity.x  = -direction * knockhit
	#				
				
	#	if step_perms:
	#		velocity.y = -100
			
	#	if kp == false:
	#		velocity.x = direction * speed
	#	
	#	move_and_slide(velocity,Vector2.UP)



func set_direction():
	if global_position.direction_to(Player.global_position).x > 0:
		direction = 1
		$Sprite.scale.x = -direction
		$raycasts.scale.x = direction
	elif global_position.direction_to(Player.global_position).x < 0:
		direction = -1
		$Sprite.scale.x = -direction
		$raycasts.scale.x = direction
	else:
		direction = 0
	




func check_way():
	if stop_from_distance == false:
		var down_center = false
		var down_side = false
		var center = false
		var head = false
		for cast_set in $raycasts.get_children():
			for cast in cast_set.get_children():
				if cast.name == "down_center":
					if cast.is_colliding():
						down_center =true
					else:
						down_center = false
				if cast.name == "down_side":
						if cast.is_colliding():
							down_side =true
						else:
							down_side = false
				if cast.name == "head":
						if cast.is_colliding():
							head =true
						else:
							head = false
				if cast.name == "center":
						if cast.is_colliding():
							center =true
						else:
							center = false
				
		if down_side == true and  (center == false and head == false):
			step_perms = true
		else:
			step_perms = false



		if (head == true or center == true) and down_center:
			if zombie_is_stop == false:
				set_physics_process(false)
				zombie_is_stop = true
			
				#print("stoped_zombie")
		if (head == false and center == false):
			if zombie_is_stop == true:
				set_physics_process(true)
				#print("activated_zombie")
				zombie_is_stop = false


func spread_parts(part_counts):
	while part_counts> 0:
	#$Sprite.hide()
		var new_part = zombie_part.instance()
		new_part.set_deferred("global_position",global_position)
		get_tree().current_scene.call_deferred("add_child", new_part)
		#new_part.linear_velocity(Vector2(100,-100))
		part_counts -= 1

func dead():
	$CollisionShape2D.set_deferred("disabled",true)
	set_physics_process(false)
	set_process(false)
	spread_parts(10)
	var Pillars = get_tree().get_nodes_in_group("MPillar")
	for pillar in Pillars:
		if pillar.active == true:
			Globals.Pillar_dead_zombie +=1
	$Dead.start()
	#Globals.dead_zombie +=1
func hit(damage,knockback):
	velocity.x = -direction *(speed + knockback)
	velocity = move_and_slide(velocity,Vector2.UP)
	$Tween.interpolate_property($Sprite.get_material(),"shader_param/flash_modifer",1,0,0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()#tweenin islemeyi ucun get_material ve shader_param/resourcedan local_to_scene aktivlesdirmek lazimdi
	healt -= damage
	spread_parts(5)
	var percent = 0
	percent = round((100 * healt)/full_healt)
	
	if percent >= 55 and percent <= 75:
		get_node("Sprite").frame = 1
	 
	if percent >= 15 and percent <= 35:
		get_node("Sprite").frame = 2
		
	if percent <= 0:
		get_node("Sprite").frame = 3
		get_node("CollisionShape2D").set_deferred("disabled",true)
		dead()
		is_dead = true
		Globals.zombie_count -=1
		




func _on_Dead_timeout():
	#spread_parts()
	queue_free()
	


func _on_Destroy_Timer_timeout():
	Globals.zombie_count -=1
	queue_free()
