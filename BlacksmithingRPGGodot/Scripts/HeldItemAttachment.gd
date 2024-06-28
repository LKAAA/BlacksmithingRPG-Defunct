extends PanelContainer

@onready var item_texture = $Item
@onready var quantity_text = $QuantityText

func update_slot(item: Inventory_Slot):
	item_texture.texture = item.item.sprite
	if not item.quantity == 1:
		quantity_text.text = str(item.quantity)
	else:
		quantity_text.text = ""
