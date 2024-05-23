extends Area2D

var partner

signal _on_interact

func _on_body_entered(body):
	partner = body
	print(partner)

func _on_body_exited(body):
	partner = null

func _interact():
	_on_interact.emit()

func interact():
	if partner.interact():
		_interact()
