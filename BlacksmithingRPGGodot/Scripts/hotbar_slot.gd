extends PanelContainer

var item:Item
var quantity: int

@export var isActiveSlot: bool = false

@onready var itemSprite = $ItemTexture
@onready var quantity_text = $QuantityText

func set_item(item:Item, quantity:int = 1) -> void:
	self.item = item
	if not item:
		quantity = 0
	set_quantity(quantity)
	set_texture()

func set_quantity(new_quantity: int):
	self.quantity = new_quantity
	
	if quantity <= 1:
		quantity_text.visible = false
	else:
		quantity_text.visible = true
		quantity_text.text = "%s" % quantity

func set_texture():
	if item:
		itemSprite.texture = item.sprite

