extends Node2D


var item_name 
var item_quantify



func _ready():
	$Sprite.position.x += 16
	$Sprite.position.y += 16
	
	var rand_val = randi()% 3
	
	
	if rand_val == 0:
		item_name = "Zombie Eye"
	elif rand_val == 1:
		item_name = "Medkit"
	elif rand_val == 2:
		item_name = "9mm"
		
	$Sprite.texture = load("res://Inventory_prototype/Item_icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantify = randi()%stack_size+1#randiler savelerle deyisecek
	
	
	if stack_size == 1:
		$Sprite/Label.visible = false
	else:
		#$Label.visible = true !!!!!!!!!ehtiyaci ola biler
		$Sprite/Label.text = String(item_quantify)
		
func set_item(nm,qt):
	item_name = nm
	item_quantify = qt
	$Sprite.texture = load("res://Inventory_prototype/Item_icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Sprite/Label.visible = false
	else:
		$Sprite/Label.visible = true
		#print(item_quantify)
		$Sprite/Label.text = String(item_quantify)



	
func add_item_quantify(amaunt_add):
	item_quantify += amaunt_add
	$Sprite/Label.text = String(item_quantify)
	
func decrase_item_quantify(amaunt_to_remove):
	item_quantify -= amaunt_to_remove
	$Sprite/Label.text = String(item_quantify)
