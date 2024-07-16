extends PanelContainer

signal hot_bar_use(index: int)
var activeSlot: int = 0

const Slot = preload("res://inventory/slot.tscn")

@onready var active_slot_marker: TextureRect = $ActiveSlotMarker
@onready var h_box_container: HBoxContainer = $TextureRect/HBoxContainer

func _ready() -> void:
	PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		if activeSlot == 0:
			activeSlot = 11
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		else:
			activeSlot -= 1
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
	
	if Input.is_action_just_pressed("scroll_down"):
		if activeSlot == 11:
			activeSlot = 0
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		else:
			activeSlot += 1
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
	
	match activeSlot:
		0:
			active_slot_marker.position = Vector2(0, 0)
		1:
			active_slot_marker.position = Vector2(18, 0)
		2:
			active_slot_marker.position = Vector2(36,0)
		3:
			active_slot_marker.position = Vector2(36+18,0)
		4:
			active_slot_marker.position = Vector2(36+18+18,0)
		5:
			active_slot_marker.position = Vector2(36+18+18+18,0)
		6:
			active_slot_marker.position = Vector2(36+36+36,0)
		7:
			active_slot_marker.position = Vector2(72+36+18,0)
		8:
			active_slot_marker.position = Vector2(72+72,0)
		9:
			active_slot_marker.position = Vector2(72+72+18,0)
		10:
			active_slot_marker.position = Vector2(72+72+36,0)
		11:
			active_slot_marker.position = Vector2(72+72+36+18,0)

func _unhandled_key_input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
	
	match event.keycode:
		KEY_1:
			activeSlot = 0
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_2:
			activeSlot = 1
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_3:
			activeSlot = 2
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_4:
			activeSlot = 3
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_5:
			activeSlot = 4
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_6:
			activeSlot = 5
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_7:
			activeSlot = 6
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_8:
			activeSlot = 7
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_9:
			activeSlot = 8
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_0:
			activeSlot = 9
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_MINUS:
			activeSlot = 10
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))
		KEY_EQUAL:
			activeSlot = 11
			PlayerManager.set_active_item(PlayerManager.player.inventory_data.get_slot_data(activeSlot))

func use_hot_bar_slot():
	hot_bar_use.emit(activeSlot)

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_hot_bar)
	populate_hot_bar(inventory_data)
	hot_bar_use.connect(inventory_data.use_slot_data)

func populate_hot_bar(inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas.slice(0,12):
		var slot = Slot.instantiate()
		h_box_container.add_child(slot)
		
		if slot_data:
			slot.set_slot_data(slot_data)
