extends Button

class_name BookmarkButton

@export var buttonType: String
@export var inUseTexture: Texture
@export var notInUseTexture: Texture
@export var tabNumber: int

var inUse: bool

@onready var not_in_use_texture = $NotInUseTexture
@onready var in_use_texture = $InUseTexture

func _ready():
	not_in_use_texture.texture = notInUseTexture
	in_use_texture.texture = inUseTexture
	not_in_use_texture.visible = true
	in_use_texture.visible = false

func _on_mouse_entered():
	if not inUse:
		not_in_use_texture.visible = false
		in_use_texture.visible = true

func _on_mouse_exited():
	if not inUse:
		not_in_use_texture.visible = true
		in_use_texture.visible = false

func _on_pressed():
	var root = get_parent()
	root.button_pressed(buttonType)

func set_in_use():
	inUse = true
	not_in_use_texture.visible = false
	in_use_texture.visible = true

func set_not_in_use():
	inUse = false
	not_in_use_texture.visible = true
	in_use_texture.visible = false
