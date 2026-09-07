extends Node2D


onready var line = get_node("Line2D")
onready var end =  null #end node

var cast_length = -330

func _ready()-> void:
	$RayCast2D.cast_to = Vector2(cast_length,0)


func _physics_process(_delta: float)-> void:
	pass


func shoot(damage,knonkback,angle):
	randomize()
	var hit_angle = round(rand_range(-angle,angle))*3
	$RayCast2D.cast_to.y = hit_angle
	
	if $RayCast2D.is_colliding():
		shoot_fire(0.1)
		var cast = $RayCast2D.to_local($RayCast2D.get_collision_point())
		line.points[1].x = cast.x
		line.points[1].y = cast.y
		if $RayCast2D.get_collider().is_in_group("Enemy"):
			var enemy = $RayCast2D.get_collider()
			enemy.hit(damage,knonkback)
	else:
		shoot_fire(0.1)
		line.points[1].x = $RayCast2D.cast_to.x
		line.points[1].y = $RayCast2D.cast_to.y*5
		
		



func shoot_fire(bullet_speed):
	$Tween.interpolate_property(line,"default_color",Color(1,1,1,1),Color(1,1,1,0),bullet_speed,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()
