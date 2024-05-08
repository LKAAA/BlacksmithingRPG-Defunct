extends Node

var skills = {}

var totalLevel = 00

var maxLevel = 10
var totalXP

var skillToAdjust
var requiredXP

var xpTable = [100, 180, 310, 550, 800, 1200, 1850, 2700, 3800, 5000] # Total 16490 XP

func _ready():
	
	# Put items in a dictionary for quick access
	for child in get_children():
		skills[child.name] = child
	
	print(skills)
	pass

func gainXP(xpToGain: int, skillName: String):
	# Determine skill to adjust
	skillToAdjust = getSkill(skillName)
	
	# Check if skill is at max level
	if skillToAdjust.curLevel == maxLevel:
		print("At max level")
		pass
	else:
		# Determine skillss current level and required xp
		var curSkillLevel
		curSkillLevel = skillToAdjust.curLevel
		requiredXP = xpTable[curSkillLevel]
		#print("requiredXP = " + str(requiredXP))
		
		# If skill's current xp would go over the current level requirement then commence level up
		if (skillToAdjust.curXP + xpToGain) >= requiredXP:
			levelUp(xpToGain)
		# Otherwise add the requested amount of xp to the skill
		else:
			skillToAdjust.curXP += xpToGain
			#print("Increased xp by " + str(xpToGain) + ". It is now: " + str(skillToAdjust.curXP))
			skillToAdjust = null
			requiredXP = null

func getSkill(skill_name):
	if (skills.has(skill_name)):
		return skills[skill_name]

func levelUp(xpToGain: int):
	print("Leveled up!")
	
	# increase the skills level
	skillToAdjust.curLevel += 1
	totalLevel += 1
	print(skillToAdjust.curLevel)
	print(totalLevel)
	
	# find leftover xp
	var neededXP
	var leftoverXP
	neededXP = requiredXP - skillToAdjust.curXP
	leftoverXP = xpToGain - neededXP
	
	# set cur xp to leftoverXP
	gainXP(leftoverXP, skillToAdjust.name)
