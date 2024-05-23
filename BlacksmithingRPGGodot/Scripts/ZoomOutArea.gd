extends Area2D


func _on_body_entered(_body):
	print(_body.name)
	
	_body.zoom_out_camera()

func _on_body_exited(body):
	body.zoom_in_camera()
