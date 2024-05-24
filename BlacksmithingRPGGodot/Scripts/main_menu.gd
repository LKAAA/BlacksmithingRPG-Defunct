extends Control

@onready var start_button = $StartButton
@onready var options_button = $OptionsButton
@onready var quit_button = $QuitButton

func _ready():
	start_button.pressed.connect(self._on_StartButton_pressed)
	options_button.pressed.connect(self._on_OptionsButton_pressed)
	quit_button.pressed.connect(self._on_QuitButton_pressed)

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://TEMP/TestingWorld.tscn")

func _on_OptionsButton_pressed():
	print("Options button pressed")

func _on_QuitButton_pressed():
	print("Quit button pressed")
