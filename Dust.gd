extends AnimatedSprite




var pos1=Vector2.ZERO
var dust_color
func _ready():
	if Globals.dust_color != "":
		dust_color = Globals.dust_color_list[Globals.dust_color]
	else:
		dust_color = Color(1,1,1,1)
	$Tween.interpolate_property(self,"modulate",dust_color,Color(dust_color.r,dust_color.g,dust_color.b,0),1,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"rotation_degrees",0,45,1,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"position",pos1,Vector2(pos1.x,pos1.y-16),1,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"frame",0,7,1,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	queue_free()
