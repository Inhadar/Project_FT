extends Node2D


var pillar = preload("res://areas/Mutant_Pillar.tscn")
var old_pillar_pos = Vector2()
var pillar_count =0



func _process(delta):
	spawn_pillar()



func spawn_pillar():
	if pillar_count < 10:
		var one_pillar = pillar.instance()
		one_pillar.position.x = old_pillar_pos.x
		old_pillar_pos.x += 5000
		add_child(one_pillar)
		pillar_count += 1
