extends StaticBody2D

class_name Note

@export var note_type: int = 1
@export var move_duration: float = 2.0
@export var max_score: int = 100
@export var min_score: int = 0
@export var hit_tolerance: float = 100.0  # Must match the value in main.gd
@export var noteSpeed: float = 0.5

func _ready():
	set_note_type()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", -100, move_duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_speed_scale(noteSpeed)
	tween.play()

func set_note_type():
	var rng = RandomNumberGenerator.new()
	note_type = rng.randf_range(1, 5)
	var sprite = self.get_child(0)
	var original_texture = sprite.texture
	var new_texture = original_texture.duplicate() # Create a new instance of the texture
	match note_type:
		1:
			new_texture.region = Rect2(16,0,16,16)
		2:
			new_texture.region  = Rect2(32,0,16,16)
		3:
			new_texture.region  = Rect2(48,0,16,16)
		4:
			new_texture.region  = Rect2(0,0,16,16)
	sprite.texture = new_texture

func get_score(distance: float) -> int:
	if distance <= hit_tolerance:
		var score_range = max_score - min_score
		var score = max_score - int((distance / hit_tolerance) * score_range)
		return max(min_score, score)
	return 0
