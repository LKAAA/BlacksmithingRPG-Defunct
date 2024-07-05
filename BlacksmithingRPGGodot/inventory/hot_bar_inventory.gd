extends PanelContainer

signal hot_bar_use(index: int)
var activeSlot: int = 0
var slots: Array[Vector2]

const Slot = preload("res://inventory/slot.tscn")

@onready var active_slot_marker: TextureRect = $ActiveSlotMarker
@onready var h_box_container: HBoxContainer = $TextureRect/HBoxContainer

func _unhandled_key_input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
	
	match event.keycode:
		KEY_1:
			activeSlot = 0
			hot_bar_use.emit(0)
		KEY_2:
			activeSlot = 1
			hot_bar_use.emit(1)
		KEY_3:
			activeSlot = 2
			hot_bar_use.emit(2)
		KEY_4:
			activeSlot = 3
			hot_bar_use.emit(3)
		KEY_5:
			activeSlot = 4
			hot_bar_use.emit(4)
		KEY_6:
			activeSlot = 5
			hot_bar_use.emit(5)
		KEY_7:
			activeSlot = 6
			hot_bar_use.emit(6)
		KEY_8:
			activeSlot = 7
			hot_bar_use.emit(7)
		KEY_9:
			activeSlot = 8
			hot_bar_use.emit(8)
		KEY_0:
			activeSlot = 9
			hot_bar_use.emit(9)
		KEY_MINUS:
			activeSlot = 10
			hot_bar_use.emit(10)
		KEY_EQUAL:
			activeSlot = 11
			hot_bar_use.emit(11)

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
