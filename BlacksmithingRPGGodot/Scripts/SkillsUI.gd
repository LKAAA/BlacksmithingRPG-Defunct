extends Control

@onready var mining_label = $LeftPage/MiningLabel
@onready var foraging_label = $LeftPage/ForagingLabel
@onready var combat_label = $LeftPage/CombatLabel
@onready var leatherworking_label = $LeftPage/LeatherworkingLabel
@onready var woodworking_label = $LeftPage/WoodworkingLabel
@onready var forging_label = $LeftPage2/ForgingLabel
@onready var assembling_label = $LeftPage2/AssemblingLabel
@onready var rune_etching_label = $LeftPage2/RuneEtchingLabel
@onready var cooking_label = $LeftPage2/CookingLabel
@onready var fishing_label = $LeftPage2/FishingLabel

func update_labels() -> void:
	var levels = PlayerManager.get_skills()
	
	mining_label.text = "Mining\n" + levels[0]
	foraging_label.text = "Foraging\n" + levels[1]
	combat_label.text = "Combat\n" + levels[2]
	leatherworking_label.text = "Leatherworking\n" + levels[3]
	woodworking_label.text = "Woodworking\n" + levels[4]
	forging_label.text = "Forging\n" + levels[5]
	assembling_label.text = "Assembling\n" + levels[6]
	rune_etching_label.text = "Rune Etching\n" + levels[7]
	cooking_label.text = "Cooking\n" + levels[8]
	fishing_label.text = "Fishing\n" + levels[9]
