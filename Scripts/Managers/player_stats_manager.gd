extends Node

var curStamina
var maxStamina

var defense
var strength

#region Stamina Functions

func increaseStamina(staminaToGain: int): # Gain a specified amount of stamina, prevents going over
	if curStamina + staminaToGain >= maxStamina: 
		curStamina = maxStamina
	else:
		curStamina += staminaToGain

func decreaseStamina(decreaseAmount: int): 
	pass
	if (curStamina - decreaseAmount) <= 0: # if this would reduce stamina to 0
		print("Out of stamina")
		curStamina = 0
	else: 
		curStamina -= decreaseAmount

func setStamina(staminaNewNum: int): # Set current stamina to any specified number
	curStamina = staminaNewNum

func fullStaminaRestore():
	curStamina = maxStamina

func changeMaxStamina(maxStaminaNewNum: int): # Set max stamina to a specified number
	maxStamina = maxStaminaNewNum

#endregion

