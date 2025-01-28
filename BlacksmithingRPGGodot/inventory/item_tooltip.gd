extends Control

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func Config(item_data, for_text):
	if not rich_text_label:
		await self.ready
	
	rich_text_label.text = for_text
