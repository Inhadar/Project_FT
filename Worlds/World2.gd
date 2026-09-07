extends Node




func _ready():
	Globals.zombie_count  = 0
	Globals.block_count  = 0
	for button in $CanvasLayer/GridContainer.get_children():
		button.connect("pressed",self,"Button_pressed",[button.name])



func _process(delta):
	$CanvasLayer/Label.text = "FPS: " + str(Engine.get_frames_per_second())
	$CanvasLayer/Label2.text = "Zombie_count: " + str(Globals.zombie_count)
	
	$CanvasLayer/Label3.text = "Block_count: " + str(Globals.block_count)


func _on_Button_pressed():
	get_tree().reload_current_scene()

