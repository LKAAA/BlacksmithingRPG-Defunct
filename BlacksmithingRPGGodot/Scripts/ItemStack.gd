extends Resource
class_name ItemStack

var item:Item = null
var quantity:int = 0


func _init(item:Item = null, quantity:int = 0) -> void:
	self.item = item
	self.quantity = quantity


func _get_property_list() -> Array:
	return [
		{
			"name": "item",
			"type": TYPE_OBJECT,
			"usage": PROPERTY_USAGE_STORAGE
		},
		{
			"name": "quantity",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_STORAGE
		},
	]
