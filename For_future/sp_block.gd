extends RigidBody2D




var level_1_blocks_1 = [
	"ThornPlantblock_1",
	"SandStoneblock_1",
	"Metalblock_1"
	]
var level_1_blocks_2 = [
	"ThornPlantblock_2",
	"SandStoneblock_2",
	"Metalblock_2"
	]
var level_2_blocks = []
var level_3_blocks = []


onready var drop_item = preload("res://Inventory_prototype/Item/DropItem.tscn")


var counter_permission = true
var block_position
var block
var health = 100


var velocity = Vector2.ZERO
onready var Player = get_tree().get_root().get_node("World/Player")

func _ready():
	$Sprite.texture = load("res://Inventory_prototype/Item_icons/" + block +".png")
	
	block_position =global_position

	$VisibilityNotifier2D.connect("screen_entered",self,"show")
	$VisibilityNotifier2D.connect("screen_exited",self,"hide")
	visible = false
	set_physics_process(false)

func show():
	visible  = true
	set_physics_process(true)
func hide():
	visible = false
	
func _physics_process(delta):
	n_checker()

	if global_position.distance_to(Player.global_position) > 3000:
		set_physics_process(false)
func n_checker():
	var left = false
	var right = false
	var down = false
	var cast_is_active =false
	if self.linear_velocity.y != 0:
		$cast/left.enabled = true
		$cast/right.enabled = true
		cast_is_active = true
	else:
		$cast/left.enabled = false
		$cast/right.enabled = false
		cast_is_active = false

	#print(linear_velocity) 
	for a in $cast.get_children():
		if a.is_colliding():
			if a.get_collider() is StaticBody2D:
				#print(a.get_collider().block_type)
				if a.get_collider().block_type != "level0":#bunu spesifik olaraq deyisdire bilerik
					break_self()
			
			if a.get_collider() is RigidBody2D:
				#print(round(global_position.y)," / ",round(a.get_collider().global_position.y))
				#if round(linear_velocity.y) == 0:
				#if round(global_position.y) == round(a.get_collider().global_position.y):
					
				if round(self.global_position.y) == round(a.get_collider().global_position.y):
					#set_mode(RigidBody2D.MODE_STATIC)
					#sleeping = true
					pass
			
			if a.name == "down":
				if a.get_collider() is KinematicBody2D:
					break_self()
		
		
		
		
		
		
			if a.name == "left":
				left= true
			else:left = false
			if a.name == "right":
				right =true
			else:right = false
			if a.name == "down":
				down = true
			else:down = false
			
	if down == false:
		set_mode(RigidBody2D.MODE_CHARACTER)
		modulate = Color(1,1,1)
		$Timer.start()
			
			
		if left == false and right == false and cast_is_active ==true:
			#set_mode(RigidBody2D.MODE_CHARACTER)
			#sleeping = false
			pass
	"""
	var contact_bodies = get_colliding_bodies()
	
	if contact_bodies.size()>0:
		for body in contact_bodies:
			if !body in [StaticBody2D]:
				#sleeping =true
				pass
			#else:
			#	sleeping = false
			
				
	"""
func break_self():
	var drop_item_instance
	if is_in_group("1"):
		drop_item_instance = drop_item.instance()
	elif is_in_group("2"):
		drop_item_instance = drop_item.instance()
		drop_item_instance.modulate.r= 4
		drop_item_instance.modulate.g= 6
		drop_item_instance.modulate.b= 5
		
		
	drop_item_instance.item_name = block
	drop_item_instance.global_position = global_position
	get_tree().root.get_node("World").add_child(drop_item_instance)
	drop_item_instance.throw()
	queue_free()
	
func _on_Timer_timeout():
	set_mode(RigidBody2D.MODE_STATIC)	
	$Sprite.modulate = Color(1,1,1)


