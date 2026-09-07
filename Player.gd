extends KinematicBody2D


#######Weapons variables############

var weapon_list = [
	"Pipe","9mm","Ak12",
	"AK57","AWP","Boomer_riffle",
	"Makar","Mp5","Scar",
	"Scar_Two","Shotgun",
	"Tactical_shotgun","Uzi"
	]
	



var weapon_class_melee = {
	"slow":[],
	"normal":["Pipe"],
	"speed":[]
	}
var weapon_class_pistol = {
	"heavy":[],
	"normal":["9mm"],
	"speed":[]
	}
var weapon_class_shotgun = {
	"slow":[],
	"normal":["Shotgun"],
	"speed":[]
	}
var weapon_class_riffle = {
	"impluse":["Scar","Scar_Two"],
	"normal":["Ak12","AK57","Boomer_riffle"],
	"speed":[]
	}
var weapon_class_sniper = {
	"slow":[],
	"normal":[]
	}
var weapon_class_special = {
	
}




var weapon_classes = {
	"Melee":weapon_class_melee,
	"Pistol":weapon_class_pistol,
	"Shotgun":weapon_class_shotgun,
	"Riffle":weapon_class_riffle,
	"Sniper":weapon_class_sniper,
	"Special":weapon_class_special
}

var current_weapon_class
var current_weapon_under_class
var current_weapon
######End########






export var dust : PackedScene

#var shoot_fire = preload("res://Effects/Shoot_fire/Shoot_fire.tscn")

var gravity = 2000
var speed =350
var current_direction = 0

var stair_permision = false
var h_head = false
var h_center = false
var v_side = false
var v_center = false

var fire_permision = true
var check_shoot = false
#->Start
var velocity = Vector2()
var UP= Vector2.UP
var check_weapon = false
#onready var m_weapon = get_node("Anime_Set/Attack/Node2D")


#--> Raycasts
#onready var H_Direction_Raycasts = $Direction_Checks/H_raycasts.get_children()
#onready var V_Direction_Raycasts = $Direction_Checks/V_raycasts.get_children()

var dir_list = []
var hit_req = false
var last_x_dir = 1




#--> Speed Settings
var max_h_speed = 400
var max_v_speed = 100
var accleration = 500
var max_fall = 1000
var jump_force = -500
var jump_hold_time = 0.27
var local_hold_time = 0
var direction_x 
var direction_y 

var gravity_direction = []
var true_ground_for_dust = false
var dust_permission = false
#Attack_vars
var attack_move_permsion = true
var on_floor = false
var anim_perm = true#animasiyani serhedlendirmek ucun
#End->

var weapon_changing = false
onready var muzzle= $Sprite_Set/Muzzle
var hit_rate

func _ready(): 
	change_current_weapon()

func _input(_event):
	#if event.is_action_pressed("Pick"):
	if $Pick_Area.items_in_range.size()>0:
		var pickup_item = $Pick_Area.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$Pick_Area.items_in_range.erase(pickup_item)

func _physics_process(delta):
	if !on_floor:
		add_gravity(delta)
	move_to_direction(delta)
	jump(delta)
	#2change_current_weapon()
	attack()
	animation_base()
	
	var under_block = $raycasts/vertical/down_center1.get_collider()
	if  under_block is StaticBody2D:
		Globals.dust_color = under_block.block_type
	

	
	velocity = move_and_slide_with_snap(velocity,Vector2(0,-32),Vector2.UP,false,4,deg2rad(60),false)
	




func add_gravity(delta):
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)

func move_to_direction(delta):
	direction_x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	
	if direction_x != 0:
		last_x_dir = direction_x
		
	velocity.x = move_toward(velocity.x,max_h_speed * direction_x,accleration * delta)
	if direction_x != 0:
		$Sprite_Set.scale.x = -direction_x
		$raycasts.scale.x = direction_x

func jump(delta):
	local_hold_time -= delta
	if Input.is_action_just_pressed("Jump") and on_floor:
			#velocity.x = 0 --> ziplarken dayan (opsiyonel)
			yield(get_tree().create_timer(0.06),"timeout")
			velocity.y = jump_force
			local_hold_time = jump_hold_time
	elif local_hold_time > 0:
		if Input.is_action_pressed("Jump"):
			velocity.y = jump_force
		else:
			local_hold_time = 0

func animation_base():
	
	var moving = false
	var jumping = false
	var falling = false
	var stoping = false
	var idle = false
	
	var front_is_blocked = false
	
	if $raycasts/vertical/down_side.is_colliding():
		front_is_blocked = true
	else:
		front_is_blocked = false
	
	for i in range(1,4):
		var dc = get_node("raycasts/vertical/down_center" + str(i))
		if dc.is_colliding() or is_on_floor():#is_on_floor castlarin 
			on_floor = true#islemediyi spesifik veziyerler ucun isledirlir
			anim_perm = true
			if dc.get_collider() is StaticBody2D:#burdan tileslarda toz cixacaq ya yox
				true_ground_for_dust = true# ayarlamaq olar
			else:
				true_ground_for_dust = false
			break
		else:
			on_floor = false
	
	if direction_x != 0 and velocity.x != 0 and on_floor and front_is_blocked == false:
		moving = true
	else:
		moving = false
		
	if velocity.x != 0 and direction_x == 0 and on_floor:
		stoping = true
	else:
		stoping = false
		
	if Input.is_action_just_pressed("Jump") and on_floor:
		jumping = true
	else:
		jumping = false
		
	if on_floor==false and velocity.y > 200:
		falling = true
	else:
		falling = false
		
		
		
	if moving == false and stoping == false and jumping == false and falling == false and on_floor:
		idle = true
	else:
		idle = false
		
		
	if jumping:
		$Player_anim.play("Jump")
		if current_weapon == null:
			$Weapon_anim.play("None_Jump")
	if $Player_anim.current_animation != "Jump":
		if moving:
			$Player_anim.play("Run")
			if current_weapon == null:
				$Weapon_anim.play("None_Run")
		if stoping:
			$Player_anim.play("Stop")
			if current_weapon == null:
				$Weapon_anim.play("None_Stop")
		if falling:
			if anim_perm:
				$Player_anim.play("Fall")
				if current_weapon == null:
					$Weapon_anim.play("None_Fall")
				anim_perm = false
		if idle:
			$Player_anim.play("Idle")
			if current_weapon == null:
				$Weapon_anim.play("None_Idle")
				pass
		
		
	####Dust decetion codes#########
	if true_ground_for_dust:
		if on_floor and velocity.x != 0 and front_is_blocked == false:
			if dust_permission == true:
				$Dust_Timer.start()
				dust_permission = false
		else:
			if dust_permission == false:
				$Dust_Timer.stop()
				dust_permission =true

func change_current_weapon():
	
	
	for i in range(0,3):
		if i in PlayerInventory.equips_weapon.keys():
			get_node("Sprite_Set/body/arms/Weapon"+str(i+1)).visible = true
			var weapon = PlayerInventory.equips_weapon[i][0]
			get_node("Sprite_Set/body/arms/Weapon"+str(i+1)+"/Weapon").texture = load("res://Assets/weapons/Guns/"+weapon+".png")
			
		else:
			get_node("Sprite_Set/body/arms/Weapon"+str(i+1)).visible = false

	if PlayerInventory.active_weapon_slot == 0:
		
		if PlayerInventory.equips_weapon.has(0):
			if Globals.current_weapon != PlayerInventory.equips_weapon[0][0]:
				current_weapon = PlayerInventory.equips_weapon[0][0]
				current_weapon_class = JsonData.item_data[current_weapon]["ItemCategory"]
				current_weapon_under_class = JsonData.item_data[current_weapon]["ShootType"]
				Globals.current_weapon = PlayerInventory.equips_weapon[0][0]
				weapon_changing = true
				check_weapon_animation(true,false)
				PlayerInventory.emit_signal("active_weapon_updated")
		else:
			if current_weapon != null:
				current_weapon = null
				current_weapon_class = null
				current_weapon_under_class =null
				$Weapon_anim.current_animation = "None_Idle"#We can change to weapon pick animation
				$Weapon_anim.seek(0.1,true)#Set animeation postion to handle gun
				$Weapon_anim.stop()# this stop change anitmation stop
				weapon_changing = true
				#check_weapon_animation(true,false)
				PlayerInventory.emit_signal("active_weapon_updated")
	
	elif PlayerInventory.active_weapon_slot == 1:
		if PlayerInventory.equips_weapon.has(1):
			if Globals.current_weapon != PlayerInventory.equips_weapon[1][0]:
				current_weapon = PlayerInventory.equips_weapon[1][0]
				current_weapon_class = JsonData.item_data[current_weapon]["ItemCategory"]
				current_weapon_under_class = JsonData.item_data[current_weapon]["ShootType"]
				Globals.current_weapon = PlayerInventory.equips_weapon[1][0]
				weapon_changing = true
				check_weapon_animation(true,false)
				PlayerInventory.emit_signal("active_weapon_updated")
		
		else:
			if current_weapon != null:
				current_weapon = null
				current_weapon_class = null
				current_weapon_under_class =null
				$Weapon_anim.current_animation = "None_Idle"#We can change to weapon pick animation
				$Weapon_anim.seek(0.1,true)#Set animeation postion to handle gun
				$Weapon_anim.stop()# this stop change anitmation stop
				weapon_changing = true
				#check_weapon_animation(true,false)
				PlayerInventory.emit_signal("active_weapon_updated")
	
	elif PlayerInventory.active_weapon_slot == 2:
		if PlayerInventory.equips_weapon.has(2):
			if Globals.current_weapon != PlayerInventory.equips_weapon[2][0]:
				current_weapon = PlayerInventory.equips_weapon[2][0]
				current_weapon_class = JsonData.item_data[current_weapon]["ItemCategory"]
				current_weapon_under_class = JsonData.item_data[current_weapon]["ShootType"]
				Globals.current_weapon = PlayerInventory.equips_weapon[2][0]
				weapon_changing = true
				check_weapon_animation(true,false)
				PlayerInventory.emit_signal("active_weapon_updated")
		else:
			if current_weapon != null:
				current_weapon = null
				current_weapon_class = null
				current_weapon_under_class =null
				$Weapon_anim.current_animation = "None_Idle"#We can change to weapon pick animation
				$Weapon_anim.seek(0.1,true)#Set animeation postion to handle gun
				$Weapon_anim.stop()# this stop change anitmation stop
				weapon_changing = true
				#check_weapon_animation(true,false)
				PlayerInventory.emit_signal("active_weapon_updated")

func check_weapon_animation(ready,attack):
		if ready:
			if $Weapon_anim.current_animation != current_weapon_class+"_"+current_weapon_under_class+"_"+"ready":
				$Weapon_anim.play(current_weapon_class+"_"+current_weapon_under_class+"_"+"ready")
		if attack:
			if $Weapon_anim.current_animation != current_weapon_class+"_"+current_weapon_under_class:
				$Weapon_anim.current_animation = current_weapon_class+"_"+current_weapon_under_class
				
				if current_weapon != null and current_weapon_class != "Melee":
					if current_weapon_class == "Pistol":
						var fire_pos = $Sprite_Set/body/arms/Weapon2/Weapon/Position2D
						var _posX = fire_pos.global_position.x - (sign(fire_pos.global_position.x)*40)
						var _posY = fire_pos.global_position.y 
						muzzle.global_position = fire_pos.global_position
						set_weapon_settings()
					elif current_weapon_class == "Riffle":
						var fire_pos = $Sprite_Set/body/arms/Weapon3/Weapon/Position2D
						var _posX = fire_pos.global_position.x - (sign(fire_pos.global_position.x)*40)
						var _posY = fire_pos.global_position.y 
						muzzle.global_position = fire_pos.global_position
						set_weapon_settings()
								
				fire_permision = false

			
		#print($Weapon_anim.current_animation)

func attack():
	
	if current_weapon_class != null and current_weapon_under_class != null:
		if $Weapon_anim.current_animation != current_weapon_class+"_"+current_weapon_under_class+"_"+"ready":
			weapon_changing = false
	if current_weapon_class != null and current_weapon_under_class != null:
		if weapon_changing == false:
			if Input.is_action_pressed("Shoot") and fire_permision:
				check_weapon_animation(false,true)
				
				fire_permision = false
					#one_time_timer(wait_time)######## fire rate
			if current_weapon_class == "Melee" or (current_weapon_class=="Pistol" and current_weapon_under_class in ["normal","heavy"]):
				if Input.is_action_just_released("Shoot"):
					fire_permision = true
			if current_weapon_class == "Riffle" and current_weapon_under_class == "normal":
				one_time_timer(0.5)
				# and WeaponType == "shotgun","ariffle" ve s:
		

	"""
		if current_weapon_class == "pistol":
			check_shoot = true
			var bullet_angle = rand_range(-10,10)
			$Weapon_anim.play("Pistol")
			var pistol_bullet = pistol_ammo.instance()
			pistol_bullet.position = $Sprite_Set/body/arms/Ranged/Weapon/Position2D.global_position
			pistol_bullet.angle = 0
			get_tree().current_scene.add_child(pistol_bullet)
			fire_permision = false
			one_time_timer(0.5)
		if current_weapon_class == "riffle":
			var bullet_angle = rand_range(-10,10)
			var pistol_bullet = pistol_ammo.instance()
			pistol_bullet.position = $Sprite_Set/body/arms/Ranged/Weapon/Position2D.global_position
			pistol_bullet.angle = 0
			get_tree().current_scene.add_child(pistol_bullet)
			fire_permision = false
			one_time_timer(0.4)
			$Weapon_anim.play("riffle")
	"""

"""
func stair_climb():
	for vv in $raycasts/vertical.get_children():
		if vv.is_colliding():
			if vv.name  == "down_center":
				v_center = true
			if vv.name  == "down_side":
				v_side = true
		else:
			if vv.name  == "down_center":
				v_center = false
			if vv.name  == "down_side":
				v_side = false
			
		#print("VC/VS: ",v_c," / ",v_s)
	for hh in $raycasts/horizontal.get_children():
		if hh.is_colliding():
			if hh.name == "head":
				h_head = true
			if hh.name == "center":
				h_center = true
		else:
			if hh.name == "head":
				h_head = false
			if hh.name == "center":
				h_center = false
		#print("HH/HC: ",h_head," / ",h_center)
		
	if  direction_x !=0:
		if v_side == true and  h_head == false:
			velocity.y = -150
			pass
"""

func set_weapon_settings():
	$Player_camera.shake(0.1,1)
	if current_weapon_class == "Pistol":
		if current_weapon_under_class == "heavy":
			#one_time_timer(1)
			##if Glb_crtwpn == nnnnnnnnnn set damege
			muzzle.shoot(75,1000,10)
		elif current_weapon_under_class == "normal":
			#one_time_timer(0.3)
			muzzle.shoot(25,500,15)
		elif current_weapon_under_class == "speed":
			one_time_timer(0.1)
			muzzle.shoot(15,300,20)
	elif current_weapon_class == "Riffle":
		if current_weapon_under_class == "impluse":
			one_time_timer(0.5)
			##if Gb_crtwpn == nnnnnnnnnn set damege
			muzzle.shoot(75,1000,15)
		elif current_weapon_under_class == "normal":
			one_time_timer(0.3)			
			muzzle.shoot(25,500,20)
		elif current_weapon_under_class == "speed":
			one_time_timer(0.1)
			muzzle.shoot(15,300,35)

func one_time_timer(wait_time):
	var new_timer = Timer.new()
	new_timer.wait_time = wait_time
	new_timer.one_shot = true
	add_child(new_timer)
	new_timer.connect("timeout",self,"_one_time_timer_pressed")
	new_timer.start()

func _one_time_timer_pressed():
	fire_permision = true

func _on_Timer_timeout():
	if stair_permision == false:
		stair_permision = true
	pass

func _on_Dust_Timer_timeout():
	if direction_x !=0:
		if direction_x > 0:
			var new_dust = dust.instance()
			new_dust.modulate = Globals.dust_color_list[Globals.dust_color]
			new_dust.translate(Vector2((global_position.x-8),global_position.y+32))
			new_dust.pos1 = Vector2((global_position.x-8),global_position.y+32)
			get_parent().add_child(new_dust)
		else:
			var new_dust = dust.instance()
			new_dust.translate(Vector2((global_position.x+8),global_position.y+32))
			new_dust.pos1 = Vector2((global_position.x+8),global_position.y+32)
			get_parent().add_child(new_dust)
	else:
		if velocity.x != 0:
			if velocity.x > 0:
				var new_dust = dust.instance()
				new_dust.translate(Vector2((global_position.x+16),global_position.y+32))
				new_dust.pos1 = Vector2((global_position.x+16),global_position.y+32)
				get_parent().add_child(new_dust)
			else:
				var new_dust = dust.instance()
				new_dust.translate(Vector2((global_position.x-16),global_position.y+32))
				new_dust.pos1 = Vector2((global_position.x-16),global_position.y+32)
				get_parent().add_child(new_dust)

func _on_Player_anim_animation_finished(_anim_name):
	#$Player_anim.stop()
	pass

func _on_Weapon_anim_animation_finished(_anim_name):
	#$Weapon_anim.stop()
	#fire_permision = true
	pass
