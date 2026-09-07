extends KinematicBody2D



var world_block_list = {"dirt":0,"stone":1,"basalt":2,"basis_stone":3,"infected_dirt":4}
var sp_block_list = {"sp_block1":5,"sp_block2":6,"sp_block3":7,"sp_block4":8,"sp_block5":9}
var block_library= {"world_block_list":world_block_list,"sp_block_list":sp_block_list}

var block_list: String
var block_type: String

var counter_permission = true
var block_position
var current_pillar


var velocity = Vector2.ZERO
var snap_size = 32
var snap_pos
func _ready():
	#print(block_library[block_list][block_type])
	$Sprite.frame= 5#block_library[block_list][block_type]

func _physics_process(delta):
	velocity.x = 0
	if !is_on_floor():
		velocity.normalized().y += 1000 *delta
	else:
		velocity.y = 0
	
	move_and_slide(velocity,Vector2.UP,false,4,0.785398,false)
	
