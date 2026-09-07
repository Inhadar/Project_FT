extends Sprite

var current_color = Color(1,1,1,1)



func fire(bullet_speed):
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),bullet_speed,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	$Tween.stop_all()
	hide()
