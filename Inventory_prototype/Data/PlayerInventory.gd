extends Node

signal active_item_updated
signal active_weapon_updated

const NUM_INVENTORY_SLOTS = 12
const NUM_HOTBAR_SLOTS = 5
const NUM_WBAR_SLOTS = 3
const SlotClass = preload("res://Inventory_prototype/Page/Slot.gd")
const ItemClass = preload("res://Inventory_prototype/Item/item.gd")


var block_place_perm = false

var inventory = {
	0: ["Metalblock_1" , 61],
	1: ["Metalblock_2" , 10],
	2: ["SandStoneblock_1" , 10],
	3: ["SandStoneblock_2" , 13],
	4: ["ThornPlantblock_1" , 14],
	5: ["ThornPlantblock_2" , 16],
	6: ["Plasmasword" , 1],
	7: ["Shotgun" , 1]
#	0: ["9mm" , 1], # --> slot_index: [item_name,item_quantify]
#	1: ["Medkit" , 10],
#	2: ["Zombie Eye" , 98],
#	3: ["Zombie Eye" , 50]
}


var hotbar = {
	0: ["Metalblock_1" , 61]
#	0: ["9mm" , 1], # --> slot_index: [item_name,item_quantify]
#	1: ["9mm" , 1],
#	2: ["Zombie Eye" , 98],
#	3: ["Zombie Eye" , 50]
}

var equips_weapon = {
	0: ["Pipe" , 1], # --> slot_index: [item_name,item_quantify]
	1: ["9mm" , 1],
	2: ["Ak12" , 1]
}

var equips_body = {
#	0: ["Wrench" , 1], # --> slot_index: [item_name,item_quantify]
#	1: ["Revolver" , 1],
#	2: ["Shotgun" , 1]
}



var chest = {
	
}

var active_item_slot =0
var active_weapon_slot =0

func add_item(item_name, item_quantify):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size= int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantify:
				inventory[item][1] += item_quantify
				update_slot_visual(item, inventory[item][0],inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				item_quantify = item_quantify - able_to_add
	#item dsnt exist in inventory yet,so add it an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name,item_quantify]
			update_slot_visual(i,inventory[i][0],inventory[i][1])
			return

func update_slot_visual(slot_index,item_name,new_quantify):
	var slot = get_tree().root.get_node("/root/World/Player/UI/Inventory/Inventory_area/inventory_slots/slot"+str(slot_index+1))
	if slot.item != null:
		slot.item.set_item(item_name,new_quantify)
	else:
		slot.initialize_item(item_name,new_quantify)


func update_hotbar_slot_visual(slot_index,item_name,new_quantify):
	var slot = get_tree().root.get_node("/root/World/Player/UI/Hotbar/HotbarSlots/slot"+str(slot_index+1))
	if slot.item != null:
		slot.item.set_item(item_name,new_quantify)
	else:
		slot.initialize_item(item_name,new_quantify)	
		
		
		
func remove_item(slot: SlotClass):
######################### WTF ARASDIR "MATCH" !!!!!!!!!!!!!!!!!!!!
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		SlotClass.SlotType.CHEST:
			chest[slot.slot_parent].erase(slot.slot_index)
		_:
			equips_weapon.erase(slot.slot_index)
			equips_body.erase(slot.slot_index)
			var Player = get_tree().root.get_node("/root/World/Player")
			Player.change_current_weapon()
			if !equips_weapon.has(active_weapon_slot):
				Globals.current_weapon = null
			
############################
			
			
			
func add_item_to_empty_slot(item:ItemClass, slot: SlotClass):
	block_place_perm = false
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name,item.item_quantify]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name,item.item_quantify]
		SlotClass.SlotType.CHEST:
			chest[slot.slot_parent][slot.slot_index] = [item.item_name,item.item_quantify]
		_:
			equips_weapon[slot.slot_index] = [item.item_name,item.item_quantify]
			equips_body[slot.slot_index] = [item.item_name,item.item_quantify]
			var Player = get_tree().root.get_node("/root/World/Player")
			Player.change_current_weapon()


func add_item_quantify(slot: SlotClass, quantity_to_add: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add 
		SlotClass.SlotType.CHEST:
			chest[slot.slot_parent][slot.slot_index][1] += quantity_to_add
		_:
			equips_weapon[slot.slot_index][1] += quantity_to_add 
			equips_body[slot.slot_index][1] += quantity_to_add 
			
func active_item_scroll_up():
	active_item_slot = (active_item_slot+1)%NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")


func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS -1
	else:
		active_item_slot -=1
	emit_signal("active_item_updated")


func active_weapon_scroll_up():
	active_weapon_slot = (active_weapon_slot+1)%NUM_WBAR_SLOTS
	emit_signal("active_weapon_updated")


func active_weapon_scroll_down():
	if active_weapon_slot == 0:
		active_weapon_slot = NUM_WBAR_SLOTS -1
	else:
		active_weapon_slot -=1
	emit_signal("active_weapon_updated")
