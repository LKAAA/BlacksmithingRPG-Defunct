extends PanelContainer

@onready var item_texture = $Item
@onready var quantity_text = $QuantityText

func update_slot(item: Item, heldQuantity: int):
	item_texture.texture = item.sprite
	if not heldQuantity == 1:
		quantity_text.text = str(heldQuantity)
	else:
		quantity_text.text = ""
