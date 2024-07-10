extends PanelContainer

signal hot_bar_use(index: int)
var activeSlot: int = 0

const Slot = preload("res://inventory/slot.tscn")

@onready var active_slot_marker: TextureRect = $ActiveSlotMarker
@onready var h_box_container: HBoxContainer = $TextureRect/HBoxContainer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		if activeSlot == 0:
			activeSlot = 11
		else:
			activeSlot -= 1
	
	if Input.is_action_just_pressed("scroll_down"):
		if activeSlot == 11:
			activeSlot = 0
		else:
			activeSlot += 1
	
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
		KEY_2:
			activeSlot = 1
		KEY_3:
			activeSlot = 2
		KEY_4:
			activeSlot = 3
		KEY_5:
			activeSlot = 4
		KEY_6:
			activeSlot = 5
		KEY_7:
			activeSlot = 6
		KEY_8:
			activeSlot = 7
		KEY_9:
			activeSlot = 8
		KEY_0:
			activeSlot = 9
		KEY_MINUS:
			activeSlot = 10
		KEY_EQUAL:
			activeSlot = 11

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
