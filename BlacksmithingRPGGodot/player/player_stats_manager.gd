extends Node

var cur_stamina
var max_stamina

var defense
var strength

#region Stamina Functions

func increase_stamina(stamina_to_gain: int): # Gain a specified amount of stamina, prevents going over
	if cur_stamina + stamina_to_gain >= max_stamina: 
		cur_stamina = max_stamina
	else:
		cur_stamina += stamina_to_gain
	SignalBus.updated_stats.emit()

func decrease_stamina(decrease_amount: int): 
	pass
	if (cur_stamina - decrease_amount) <= 0: # if this would reduce stamina to 0
		print("Out of stamina")
		cur_stamina = 0
	else: 
		cur_stamina -= decrease_amount
	SignalBus.updated_stats.emit()

func set_stamina(stamina_new_num: int): # Set current stamina to any specified number
	cur_stamina = stamina_new_num
	SignalBus.updated_stats.emit()

func full_stamina_restore():
	cur_stamina = max_stamina
	SignalBus.updated_stats.emit()

func increase_max_stamina(max_stamina_increase: int): # Set max stamina to a specified number
	max_stamina += max_stamina_increase
	SignalBus.updated_stats.emit()


#endregion
