extends CanvasLayer


var holding_item = null

func _input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
		get_parent().change_current_weapon()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
		get_parent().change_current_weapon()
		
	if event.is_action_pressed("weapon_down"):
		PlayerInventory.active_weapon_scroll_up()
		get_parent().change_current_weapon()
	elif event.is_action_pressed("weapon_up"):
		PlayerInventory.active_weapon_scroll_down()
		get_parent().change_current_weapon()
	
	if event.is_action_pressed("1"):
		PlayerInventory.active_weapon_slot = 0
		PlayerInventory.emit_signal("active_weapon_updated")
		get_parent().change_current_weapon()
	elif event.is_action_pressed("2"):
		PlayerInventory.active_weapon_slot = 1
		PlayerInventory.emit_signal("active_weapon_updated")
		get_parent().change_current_weapon()
	elif event.is_action_pressed("3"):
		PlayerInventory.active_weapon_slot = 2
		PlayerInventory.emit_signal("active_weapon_updated")
		get_parent().change_current_weapon()
