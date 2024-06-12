extends Button

@onready var not_in_use_texture = $NotInUseTexture
@onready var in_use_texture = $InUseTexture

func _on_mouse_entered():
	not_in_use_texture.visible = false
	in_use_texture.visible = true


func _on_mouse_exited():
	not_in_use_texture.visible = true
	in_use_texture.visible = false


func _on_button_down():
	var root = get_parent()
	root.exit_menu()
