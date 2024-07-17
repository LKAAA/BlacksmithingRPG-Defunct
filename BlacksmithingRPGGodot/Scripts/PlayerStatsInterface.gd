extends Control

var max_health: int
var max_stamina: int

@onready var health_text: Label = $HealthText
@onready var stamina_text: Label = $StaminaText

func _ready():
	PlayerManager.player.update_max_stats.connect(update_max_stats)

func update_max_stats(_max_health: int, _max_stamina: int) -> void:
	max_health = _max_health
	max_stamina = _max_stamina

func update_text(cur_health: int, cur_stamina: int) -> void:
	health_text.text = "Health: %s/%s" % [cur_health, max_health]
	stamina_text.text = "Stamina: %s/%s" % [cur_stamina, max_stamina]
