extends Control

@onready var character_sprite: TextureRect = $SpriteHolder/CharacterSprite
@onready var name_label: Label = $NameTextContainer/NameLabel
@onready var dialogue_label: Label = $DialogueTextContainer/DialogueLabel



func update_text(dialogue: String, characterName: String):
	name_label.text = characterName
	dialogue_label.text = dialogue

func update_character_sprite(sprite: Texture2D):
	character_sprite.texture = sprite
