extends RigidBody2D



onready var blood = preload("res://Blood.tscn")


func _ready():
	randomize()
	#var scale = rand_range(1.5,2)
	#$Sprite.scale= Vector2(scale,scale)
	$Sprite.frame = randi()%5
	var a = rand_range(-200,200)
	var b = rand_range(-200,200)
	set_deferred("linear_velocity",Vector2(a,b))
	set_deferred("angular_velocity",10)
	$Vanish.play("vanished")



func blood_split():
	randomize()
	var new_blood = blood.instance()
	new_blood.frame = round(rand_range(0,14))
	new_blood.translate(Vector2(global_position.x,global_position.y + 25))
	get_tree().current_scene.call_deferred("add_child",new_blood)



func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()


func _on_Zombie_part_body_entered(body):
	if body.is_in_group("block"):
		blood_split()
		#$Blood_timer.start()


func _on_Blood_timer_timeout():
	blood_split()
