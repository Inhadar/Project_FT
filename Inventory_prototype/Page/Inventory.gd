extends Control

signal inventory_input


const SlotClass = preload("res://Inventory_prototype/Page/Slot.gd")
onready var inventory_slots = $Inventory_area/inventory_slots
onready var weapon_equip_slots = $Weapon_Equip_area/equip_slots.get_children()
onready var body_equip_slots = $Body_Equip_area/equip_slots.get_children()
onready var active_weapon_label = $Weapon_Equip_area/Label


func _ready():
	$Inventory_area.connect("gui_input",self,"back_gui_input")
	$Body_Equip_area.connect("gui_input",self,"back_gui_input")
	$Weapon_Equip_area.connect("gui_input",self,"back_gui_input")
	
	PlayerInventory.connect("active_weapon_updated",self,"update_active_weapon_label")
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input",self,"slot_gui_input",[slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	for i in range(weapon_equip_slots.size()):
		var _back =weapon_equip_slots[i].connect("gui_input",self,"slot_gui_input",[weapon_equip_slots[i]])
		weapon_equip_slots[i].slot_index = i
		var _slots = PlayerInventory.connect("active_weapon_updated",weapon_equip_slots[i],"refresh_style")
	for i in range(body_equip_slots.size()):
		body_equip_slots[i].connect("gui_input",self,"slot_gui_input",[body_equip_slots[i]])
		body_equip_slots[i].slot_index = i
		
	weapon_equip_slots[0].slot_type = SlotClass.SlotType.MELEE
	weapon_equip_slots[1].slot_type = SlotClass.SlotType.PISTOL
	weapon_equip_slots[2].slot_type = SlotClass.SlotType.RIFFLE
	
	body_equip_slots[0].slot_type = SlotClass.SlotType.HEAD
	body_equip_slots[1].slot_type = SlotClass.SlotType.BODY
	body_equip_slots[2].slot_type = SlotClass.SlotType.LEGS
	

	initialize_inventory()
	initialize_weapon_equips()
	initialize_body_equips()
	update_active_weapon_label()
	
func gui_input():
	Globals.gui_input = !Globals.gui_input
	
func update_active_weapon_label():
	if weapon_equip_slots[PlayerInventory.active_weapon_slot].item != null:
		active_weapon_label.text = weapon_equip_slots[PlayerInventory.active_weapon_slot].item.item_name
	else:
		active_weapon_label.text = ""



func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0],PlayerInventory.inventory[i][1])

func initialize_weapon_equips():
	for i in range(weapon_equip_slots.size()):
		if PlayerInventory.equips_weapon.has(i):
			weapon_equip_slots[i].initialize_item(PlayerInventory.equips_weapon[i][0],PlayerInventory.equips_weapon[i][1])

func initialize_body_equips():
	for i in range(body_equip_slots.size()):
		if PlayerInventory.equips_body.has(i):
			body_equip_slots[i].initialize_item(PlayerInventory.equips_body[i][0],PlayerInventory.equips_body[i][1])


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
		else:
			gui_input()

func _input(event):
	if find_parent("UI").holding_item:
		find_parent("UI").holding_item.global_position = get_global_mouse_position()
	
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("UI").holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	

	if slot.slot_type == SlotClass.SlotType.MELEE:
		return holding_item_category =="Melee"
	elif slot.slot_type == SlotClass.SlotType.PISTOL:
		return holding_item_category =="Pistol"
	elif slot.slot_type == SlotClass.SlotType.RIFFLE:
		return holding_item_category =="Riffle"
	elif  slot.slot_type == SlotClass.SlotType.HEAD:
		return holding_item_category =="Head"
	elif  slot.slot_type == SlotClass.SlotType.BODY:
		return holding_item_category =="Body"
	elif  slot.slot_type == SlotClass.SlotType.LEGS:
		return holding_item_category =="Legs"
		
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
