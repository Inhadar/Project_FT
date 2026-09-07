extends Area2D


onready var Player =  get_tree().current_scene.get_node("Player")
var bullet_speed = 50
var direction = 0
var velocity = Vector2.ZERO
var angle = 0
var zombie = null
func _ready():
	direction =  Player.current_direction 


func _physics_process(delta):
	global_position.x += bullet_speed  * -direction
	global_position.y += angle
	if global_position.distance_to(Player.global_position) >2000:# and abs(global_position.x) > abs(Player.global_position):
		queue_free()
		

func one_timer(wait_time):
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = wait_time
	add_child(timer)
	timer.connect("timeout",self,"_Timeout")
	timer.start()
	
func _on_Pistol_bullet_body_entered(body):
	if body is KinematicBody2D or body is StaticBody2D:
		if body.is_in_group("zombie"):
			#body.set_physics_process(false)
			zombie = body
			body.kp = true
			one_timer(0.5)
			make_particles(Color(1, 0, 0),direction)
			hide()
			
			if body.kp == true:
				body.set_physics_process(true)
				body.zombie_is_stop = false
				one_timer(0.1)
			if Globals.current_weapon == "Pistol":
				body.healt = body.healt -25
				body.spread_parts(3)
				var percent = 0
				percent = round((100 * body.healt)/body.full_healt)
			elif Globals.current_weapon == "AssaultRifle":
				body.healt = body.healt -100
				body.spread_parts(5)
				var percent = 0
				percent = round((100 * body.healt)/body.full_healt)
				
				if percent >= 55 and percent <= 75:
					body.get_node("Sprite").frame = 1
				 
				if percent >= 15 and percent <= 35:
					body.get_node("Sprite").frame = 2
					
				if percent <= 0:
					body.get_node("Sprite").frame = 3
					body.get_node("CollisionShape2D").set_deferred("disabled",true)
					body.dead()
					body.dead = true
					Globals.zombie_count -=1
					
				 
		else:
			make_particles(Color(1, 0.960938, 0),-direction)
			queue_free()
		bullet_speed = 0
		#queue_free()

		
func make_particles(color,dir):
	var new_particle =CPUParticles2D.new()
	new_particle.global_position = global_position
	new_particle.emitting = false
	new_particle.one_shot =true
	new_particle.amount = 16
	new_particle.lifetime = 0.5#1.25
	new_particle.explosiveness = 0.84
	new_particle.gravity.y = 400
	new_particle.spread = 83.65
	new_particle.initial_velocity = dir * 100
	new_particle.scale_amount = 11.53
	new_particle.scale_amount_random = 1
	new_particle.modulate = color
	get_tree().current_scene.add_child(new_particle)
	new_particle.emitting = true
	
	
func _Timeout():
	
	if is_instance_valid(zombie):
		if zombie != null:
			zombie.kp = false
	#		zombie.set_physics_process(true)
	queue_free()
	
