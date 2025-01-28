extends PanelContainer

@onready var item_texture: TextureRect = $ItemTexture
@onready var quantity_label: Label = $QuantityLabel

var myItemData

func set_slot_data(slot_data: SlotData) -> void:
	myItemData = slot_data.item_data
	
	if myItemData.texture:
		item_texture.texture = myItemData.texture
	else:
		item_texture.texture = Global.DEBUG_TEXTURE
	
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()
		
