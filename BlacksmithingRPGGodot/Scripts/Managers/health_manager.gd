extends Node

var cur_health = 0
@export var max_health: int



func heal(healthToHeal: int): # Heal a specified amount of health, also prevents overflow healing
	print("healing")
	if cur_health + healthToHeal >= max_health: # if this heal would heal to above max health restrict it to max
		cur_health = max_health
	else:
		cur_health += healthToHeal
	SignalBus.updated_health.emit()

func damage(damageDealt: int): # Deal a specified amount of damage, also checked for death and emits a signal
	pass
	if (cur_health - damageDealt) <= 0: # if this damage would reduce health to 0 
		cur_health = 0
		SignalBus.death.emit()
		print("dies of cringe")
	else: 
		cur_health -= damageDealt
		SignalBus.takenDamage.emit()
	SignalBus.updated_health.emit()

func set_health(healthNewNum: int): # Set current health to any specified number
	cur_health = healthNewNum
	SignalBus.updated_health.emit()

func full_heal(): # Heal to max health
	cur_health = max_health
	print("Full Heal")
	SignalBus.updated_health.emit()

func set_max_health(max_healthNewNum: int): # Set max health to a specified number
	max_health = max_healthNewNum
	SignalBus.updated_health.emit()

func increase_max_health(max_healthIncrease: int): # Set max health to a specified number
	max_health += max_healthIncrease
	SignalBus.updated_health.emit()
