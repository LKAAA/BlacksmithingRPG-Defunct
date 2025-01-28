extends RigidBody2D

@export var slot_data: SlotData

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if slot_data.item_data.texture:
		sprite_2d.texture = slot_data.item_data.texture
	else:
		sprite_2d.texture = Global.DEBUG_TEXTURE

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.inventory_data.pick_up_slot_data(slot_data):
			queue_free()
