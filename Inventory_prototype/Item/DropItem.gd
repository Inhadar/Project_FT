extends KinematicBody2D

const ACCELERATION = 1000
const MAX_SPEED = 800
var velocity = Vector2.ZERO
var item_name = "SandStoneblock_1"

var player = null
var being_picked_up = false

func _ready():
	
	$AnimationPlayer.play("Motion")
	$Sprite.texture = load("res://Inventory_prototype/Item_icons/" + item_name + ".png")
	
	
func _physics_process(delta):
	if being_picked_up == false:
		velocity =velocity.move_toward(Vector2(0,MAX_SPEED),ACCELERATION * delta)
		velocity = move_and_slide(velocity,Vector2.UP)

	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance <  10:
			PlayerInventory.add_item(item_name,1)
			queue_free()
	velocity = move_and_slide_with_snap(velocity,Vector2(0,-32),Vector2.UP,false,4,deg2rad(60),false)
			
			

func throw():
	randomize()
	var random_x = rand_range(-100,100)
	var random_y = rand_range(-100,-100)
	
	velocity = Vector2(random_x*2,random_y*2)
	
	velocity = move_and_slide_with_snap(velocity,Vector2(0,-32),Vector2.UP,false,4,deg2rad(60),false)
	
	
	
func pick_up_item(body):
	player = body
	being_picked_up = true
