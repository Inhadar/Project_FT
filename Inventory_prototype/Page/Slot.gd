extends Panel

var empty_tex = preload("res://Inventory_prototype/Buttons/level_button_pressed.png")
var default_tex = preload("res://Inventory_prototype/Buttons/level_button_normal.png")
var selected_tex = preload("res://Inventory_prototype/Buttons/Sb_normal.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var itemClass = preload("res://Inventory_prototype/Item/item.tscn")
var item = null
var slot_index
var slot_parent
var slot_type
#enum arasdir


enum SlotType {
	HOTBAR =0,
	INVENTORY,
	CHEST,
	MELEE,
	PISTOL,
	RIFFLE,
	HEAD,
	BODY,
	LEGS
}

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	
	
	#if randi()%2==0:
	#	item = itemClass.instance()
	#	add_child(item)
	refresh_style()
		
func refresh_style():
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		set("custom_styles/panel",selected_style)
	elif item == null:
		set("custom_styles/panel",empty_style)
	else:
		set("custom_styles/panel",default_style)
	
	var W_SlotTypes = [SlotType.MELEE,SlotType.PISTOL,SlotType.RIFFLE]
	for i in W_SlotTypes:
		if i == slot_type and PlayerInventory.active_weapon_slot == slot_index:
			set("custom_styles/panel",selected_style)
	
	
func pick_from_slot():
	remove_child(item)
	#item.scale = Vector2(1.7,1.7)#bu itemin goturende olcusunu belirliyir
	var inventoryNode = find_parent("UI")
	inventoryNode.add_child(item)
	item = null
	refresh_style()

func remove_item():
	remove_child(item)
	item = null

	
func put_into_slot(new_item):
	item = new_item
	#item.scale = Vector2(1,1)#bu itemin qoyarken olcusunu belirliyir
	item.position = Vector2(0,0)
	var inventoryNode = find_parent("UI")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
func initialize_item(item_name,item_quantify):
	if item == null:
		item = itemClass.instance()
		add_child(item)
		item.set_item(item_name,item_quantify)
	else:
		item.set_item(item_name,item_quantify)
	refresh_style()
