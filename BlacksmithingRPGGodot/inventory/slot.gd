extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var slot_texture: TextureRect = $SlotTexture
@onready var item_texture: TextureRect = $SlotTexture/ItemTexture
@onready var quantity_label: Label = $QuantityLabel

var full_slot_texture: Texture = preload("res://Assets/Sprites/UI/InventorySlotWithItem.png")

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	if item_data.texture:
		item_texture.texture = item_data.texture
	else:
		item_texture.texture = Global.DEBUG_TEXTURE
	slot_texture.texture = full_slot_texture
	
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
