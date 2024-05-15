extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

func _on_intake_crafting_station_manager_turned_off():
	sprite.play("ForgeOff")

func _on_intake_crafting_station_manager_turned_on():
	sprite.play("ForgeOn")

func _on_behind_adjustment_body_exited(body):
	self.z_index = 1

func _on_behind_adjustment_body_entered(body):
	self.z_index = 3
