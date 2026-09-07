extends Node2D


const SlotClass = preload("res://Inventory_prototype/Page/Slot.gd")
onready var chest = $ChestGround/Chest_slots
onready var chest_slots = chest.get_children()

func _ready():
	for i in range(chest_slots.size()):
		chest_slots[i].connect("gui_input",self,"slot_gui_input",[chest_slots[i]])
		chest_slots[i].slot_index = i
		chest_slots[i].slot_parent = name
		chest_slots[i].slot_type = SlotClass.SlotType.CHEST
		
		
	initialize_chest()

func initialize_chest():
	for i in range(chest_slots.size()):
		if PlayerInventory.chest.has(name):
			if PlayerInventory.chest.has(i):
				chest_slots[name][i].initialize_item(PlayerInventory.chest[name][i][0],PlayerInventory.chest[name][i][1])
		else:
			PlayerInventory.chest[name] = {}

func slot_gui_input(event:InputEvent,slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if find_parent("UI").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UI").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event,slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)


func _input(event):
	if find_parent("UI").holding_item:
		find_parent("UI").holding_item.global_position = get_global_mouse_position()
	
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("UI").holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	return true
		
		
		
func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UI").holding_item,slot)
		slot.put_into_slot(find_parent("UI").holding_item)
		find_parent("UI").holding_item = null
		
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("UI").holding_item,slot)
		var temp_item = slot.item
		slot.pick_from_slot()
		temp_item.global_position = event.global_position
		slot.put_into_slot(find_parent("UI").holding_item)
		find_parent("UI").holding_item = temp_item
	
	
func left_click_same_item(slot:SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantify
		if able_to_add >= find_parent("UI").holding_item.item_quantify:
			PlayerInventory.add_item_quantify(slot,find_parent("UI").holding_item.item_quantify)
			slot.item.add_item_quantify(find_parent("UI").holding_item.item_quantify)
			find_parent("UI").holding_item.queue_free()
			find_parent("UI").holding_item = null
		else:
			PlayerInventory.add_item_quantify(slot,able_to_add)
			slot.item.add_item_quantify(able_to_add)
			find_parent("UI").holding_item.decrase_item_quantify(able_to_add)


func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UI").holding_item = slot.item
	slot.pick_from_slot()
	find_parent("UI").holding_item.global_position = get_global_mouse_position()


func _on_Button_pressed():
	$ChestGround.visible = !$ChestGround.visible
	if $ChestGround.visible == true:
		$AnimatedSprite.play("chest_open")
	if $ChestGround.visible == false:
		$AnimatedSprite.play("chest_close")
