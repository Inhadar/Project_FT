extends KinematicBody2D



#Movement Settings


#Body settings
var current_arms = "normal"


#weapon_settings
var current_m_weapon = "pipe" 
var picking_weapon = false
var pick_the_mweapon = false
var pick_weapon = ""



#->Start
var velocity = Vector2()
var UP= Vector2.UP
var check_weapon = false
onready var m_weapon = get_node("Anime_Set/Attack/Node2D")


#--> Raycasts
onready var H_Direction_Raycasts = $Direction_Checks/H_raycasts.get_children()
onready var V_Direction_Raycasts = $Direction_Checks/V_raycasts.get_children()

var dir_list = []
var hit_req = false
var last_x_dir = 1




#--> Speed Settings
var max_h_speed = 350
var max_v_speed = 100
var accleration = 500
var gravity = 1000
var max_fall = 600
var jump_force = -300
var jump_hold_time = 0.27
var local_hold_time = 0
var direction_x 
var direction_y 

var gravity_direction = []

#Attack_vars
var attack_move_permsion = true


#End->



func _ready():
	$Anime_Set/AnimationPlayer.play("Idle")
	if len(m_weapon.get_children())>0:
		picking_weapon = true
	else: 
		picking_weapon = false
	print(picking_weapon)
func _physics_process(delta):

	
	if current_arms == "normal":
		Attack()
		pick_the_weapon(pick_the_mweapon,pick_weapon)
	check_direction(delta)
	move_to_dir(delta)
	anim_base()
	jump()
	check_gravity_dir(delta)
	local_hold_time -= delta
			
		
	"""
	if !is_on_floor():
		if is_on_wall():
			if Input.is_action_just_pressed("ui_right"):#boolean ile action_pressed'e cevrile biler
				if gravity_direction in ["Up","Down"]:
					gravity_direction = "Right"
				else:
					pass#hecne olmasin
				if gravity_direction == "Left":
					gravity_direction = "Down"
					
			if Input.is_action_just_pressed("ui_left"):
				if gravity_direction in ["Up","Down"]:
					gravity_direction = "Left"
					
				elif gravity_direction == "Right":
					gravity_direction = "Down"
	
			
		if is_on_ceiling():
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				gravity_direction = "Up" 
	"""
		

	
	
	
	if velocity.y > 0 and !is_on_floor():
		pass
		$Anime_Set/AnimationPlayer.play("Fall")
	else:
		var anim_list = ["Attack","Jump"]
		var anim_list2 = ["Run","WRun"]
		if (is_on_floor() or is_on_ceiling() or is_on_wall()) and (direction_x == 0 and direction_y == 0):
			if !$Anime_Set/AnimationPlayer.current_animation in anim_list :
				$Anime_Set/AnimationPlayer.play("Idle")
				pass
	#print(velocity.y)
	
	velocity = move_and_slide(velocity,Vector2.UP)
	
	
	
	
	
	
	
	
	
	"""
	
	if Input.is_action_just_pressed("ui_accept"):
		var qelem_instance = qelem.instance()
		

		get_tree().current_scene.add_child(qelem_instance)
		qelem_instance.global_position.x = $Position2D.global_position.x
		qelem_instance.global_position.y = rand_range($Position2D.global_position.y+25,$Position2D.global_position.y-50)

		qelem_instance.scale.x *= scale.x/abs(scale.x)
		qelem_instance.velocity.x = qelem_instance.spd * scale.x/abs(scale.x)
	"""

func move_to_dir(delta):
	direction_x = sign(int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left")))
	direction_y = sign(int(Input.get_action_strength("ui_up")) - int(Input.get_action_strength("ui_down")))
	
	if direction_x != 0:
		last_x_dir = direction_x
	velocity.x = move_toward(velocity.x,max_h_speed * direction_x,accleration * delta)
	

	if direction_x > 0:
		$Anime_Set.scale.x = abs($Anime_Set.scale.x)
	elif direction_x < 0:
		$Anime_Set.scale.x = -abs($Anime_Set.scale.x)
	#print(direction_x)


func anim_base():
	
	if direction_x != 0:
		if is_on_floor() or is_on_ceiling():
			if $Anime_Set/AnimationPlayer.current_animation != "Jump":
				
				if picking_weapon:
					$Anime_Set/AnimationPlayer.play("WRun")
				else:
					$Anime_Set/AnimationPlayer.play("Run")
	if direction_y != 0:
		if is_on_wall():
			if $Anime_Set/AnimationPlayer.current_animation != "Jump":
				if picking_weapon:
					$Anime_Set/AnimationPlayer.play("WRun")
				else:
					$Anime_Set/AnimationPlayer.play("Run")
		
	else:#$Anime_Set/AnimationPlayer.play("Idle")
		pass

func add_gravity(delta):
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	

func jump():
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
			#velocity.x = 0 --> ziplarken dayan (opsiyonel)
			$Anime_Set/AnimationPlayer.play("Jump")
			yield(get_tree().create_timer(0.06),"timeout")
			velocity.y = jump_force
			local_hold_time = jump_hold_time
	elif local_hold_time > 0:
		if Input.is_action_pressed("Jump"):
			velocity.y = jump_force
		else:
			local_hold_time = 0
				
				





func check_direction(delta):

	for dir_side in $Direction_Checks.get_children():
		for dir in dir_side.get_children():
			if dir.is_colliding():
				if !dir.name in dir_list:
					dir_list.append(dir.name)
			else:
				dir_list.erase(dir.name)
	#print(dir_list)
			
func check_gravity_dir(delta):
	add_gravity(delta)


func hit_the_enemy(body:Node):
	if body.is_in_group("Enemy"):
		#$Anime_Set/Attack/Node2D.modulate = Color(1, 0.039216, 0.039216)
		#$Anime_Set/AnimationPlayer.pause_mode = true
		#$Anime_Set/Attack/Node2D/CPUParticles2D.emitting = true
		pass
		#yield(get_tree().create_timer(30),"timeout")
		#$Anime_Set/AnimationPlayer.pause_mode = false
		#$Anime_Set/Attack/Node2D.modulate = Color(1, 1, 1)


func Attack():
	if Input.is_action_just_pressed("Attack"):
		#$Anime_Set/Attack/Node2D/CPUParticles2D.emitting = false
		$Anime_Set/Attack/Node2D.modulate = Color(1, 1, 1)
		$Anime_Set/AnimationPlayer.play("Attack")
		
	
	if attack_move_permsion:
			var a = 0
			if $Anime_Set/AnimationPlayer.current_animation == "Attack":

				var anim_pos = $Anime_Set/AnimationPlayer.current_animation_position
				if anim_pos >= 0.1 and anim_pos <= 0.2:
					while a > -8:
						a-=0.5
						velocity.x -= 1 * last_x_dir
				
				if anim_pos >= 0.2:
					while a < 10:
						a+=1
						velocity.x += 1 * last_x_dir
					#attack_move_permsion = false
	
	
func pick_the_weapon(value,area):
	if value==true and Input.is_action_just_pressed("Action"):
		if area != null:
			if area[0] == "R":
				area.erase(0,1)
				current_m_weapon = area
				print(picking_weapon)
				
				var now_weapon = load("res://"+current_m_weapon+".tscn")
				var weapon_ins = now_weapon.instance()
				if picking_weapon:
					m_weapon.get_child(0).queue_free()
					m_weapon.add_child(weapon_ins)
					
				else:
					m_weapon.add_child(weapon_ins)
					picking_weapon = true

		pass











#for picking for new weapon 
func _on_HitBox_area_entered(area):
	if area.is_in_group("CM_weapon"):
		pick_the_mweapon = true
		pick_weapon = area.name

func _on_HitBox_area_exited(area):
	if area.is_in_group("CM_weapon"):
		pick_the_mweapon = false
		pick_weapon = area
		
#For test weapon add and delete
func _on_aw_pressed():
	if picking_weapon == false:
		var now_weapon = load("res://"+"pipe"+".tscn")
		var weapon_ins = now_weapon.instance()
		m_weapon.add_child(weapon_ins)
		picking_weapon = true
		
func _on_dw_pressed():
	if picking_weapon == true:
		m_weapon.get_child(0).queue_free()
		picking_weapon = false


func _on_AnimationPlayer_animation_finished(anim_name):
	attack_move_permsion = true
