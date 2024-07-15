extends Node

var debug: bool = OS.has_feature("debug")

@onready var panel: Panel = Panel.new()
@onready var canvas_layer: CanvasLayer = CanvasLayer.new()
@onready var label: Label = Label.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	if debug:
		if OS.get_name() == "Android" or OS.get_name() == "iOS":
			pass
		else:
			canvas_layer.layer = 128
			panel.size = Vector2(140, 80)
			# panel.theme = theme
			panel.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
			panel.self_modulate = Color(1, 1, 1, 0.69)
			panel.mouse_filter = Control.MOUSE_FILTER_PASS
			
	
			label.text = ""
			# rich_text_label.theme = theme
			label.set_anchors_preset(Control.PRESET_FULL_RECT)
			label.set("theme_override_fonts/font", "res://Assets/Fonts/ark-pixel-10px-monospaced-ja.ttf")
			label.set("theme_override_font_sizes/font_size", 5)
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			label.clip_text = true
			panel.add_child(label)
	
			canvas_layer.add_child(panel)
			add_child(canvas_layer)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_console"):
		if panel.visible:
			panel.visible = false
		else:
			panel.visible = true

func print(message: String) -> void:
	if debug:
		if label:
			var oldText = label.text
			label.text = (message + "\n") + oldText
