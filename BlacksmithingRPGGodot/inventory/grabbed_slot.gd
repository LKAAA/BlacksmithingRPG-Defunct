extends PanelContainer

@onready var item_texture: TextureRect = $ItemTexture
@onready var quantity_label: Label = $QuantityLabel

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	item_texture.texture = item_data.texture
	
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()
		
