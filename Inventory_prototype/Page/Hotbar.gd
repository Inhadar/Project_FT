extends Control


const SlotClass = preload("res://Inventory_prototype/Page/Slot.gd")
onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()
onready var active_item_label = $Label

func _ready():
	$ColorRect.connect("gui_input",self,"back_gui_input")
	PlayerInventory.connect("active_item_updated",self,"update_active_item_label")
	for i in range(slots.size()):
		slots[i].connect("gui_input",self,"slot_gui_input",[slots[i]])
		PlayerInventory.connect("active_item_updated",slots[i],"refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialize_hotbar()
	update_active_item_label()



func gui_input():
	Globals.gui_input = !Globals.gui_input

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		active_item_label.text = ""
		


func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0],PlayerInventory.hotbar[i][1])

func back_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			gui_input()
		else:
			gui_input()
		
func slot_gui_input(event:InputEvent,slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			gui_input()
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
			update_active_item_label()
		else:
			gui_input()
func left_click_empty_slot(slot: SlotClass):
	
	PlayerInventory.add_item_to_empty_slot(find_parent("UI").holding_item,slot)
	slot.put_into_slot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = null
	
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UI").holding_item,slot)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = temp_item
	
	
func left_click_same_item(slot:SlotClass):
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
