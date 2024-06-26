extends Control

@onready var hotbar = $HotbarTexture/Hotbar
@onready var active_slot_marker = $HotbarTexture/ActiveSlotMarker

var player: Player

func get_player(p: Player):
	player = p

func update_hotbar():
	hotbar.update_hotbar(player)
	player.chooseActiveItem()

func update_active_slot():
	match player.activeHotbarSlot:
		0: 
			active_slot_marker.set_position(hotbar._item_slots[0].position - Vector2(-2,-2))
		1: 
			active_slot_marker.set_position(hotbar._item_slots[1].position - Vector2(-2,-2))
		2: 
			active_slot_marker.set_position(hotbar._item_slots[2].position - Vector2(-2,-2))
		3: 
			active_slot_marker.set_position(hotbar._item_slots[3].position - Vector2(-2,-2))
		4: 
			active_slot_marker.set_position(hotbar._item_slots[4].position - Vector2(-2,-2))
		5: 
			active_slot_marker.set_position(hotbar._item_slots[5].position - Vector2(-2,-2))
		6: 
			active_slot_marker.set_position(hotbar._item_slots[6].position - Vector2(-2,-2))
		7: 
			active_slot_marker.set_position(hotbar._item_slots[7].position - Vector2(-2,-2))
		8: 
			active_slot_marker.set_position(hotbar._item_slots[8].position - Vector2(-2,-2))
		9: 
			active_slot_marker.set_position(hotbar._item_slots[9].position - Vector2(-2,-2))
		10: 
			active_slot_marker.set_position(hotbar._item_slots[10].position - Vector2(-2,-2))
		11: 
			active_slot_marker.set_position(hotbar._item_slots[11].position - Vector2(-2,-2))
