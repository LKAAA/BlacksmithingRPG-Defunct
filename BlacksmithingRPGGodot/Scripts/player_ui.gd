extends Control

@onready var hotbar = $HotbarTexture/Hotbar


var player: Player

func get_player(p: Player):
	player = p

func update_hotbar():
	hotbar.update_hotbar(player)
