extends Area2D

func _on_body_entered(body):
	if body == GameManager.player:
		GameManager.player.inventory.add_item("Rusty Axe" , 1)
		queue_free()
