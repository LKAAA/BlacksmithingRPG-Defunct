extends PanelContainer

class_name Inventory_Slot

var lockedSprite: Texture = preload("res://Assets/Sprites/UI/InventoryLocked.png")
var unlockedSprite: Texture = preload("res://Assets/Sprites/UI/InventorySlot.png")
#var withItemSprite: Texture = preload("res://Assets/Sprites/UI/InventorySlotWithItem.png")
var withItemSprite: Texture = preload("res://Assets/Sprites/UI/InventorySlot.png")

var item:Item
var quantity: int

var visualQuantity: int

var hovered: bool = false
var pickedUp: bool = false

var inventoryUI: InventoryUI

@export var isLocked: bool = false

@onready var slot = $Slot
@onready var itemSprite = $Item
@onready var quantity_text = $QuantityText

# Called when the node enters the scene tree for the first time.
func _ready():
	if isLocked:
		lock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		inventoryUI.update_tooltip(self)
		if Input.is_action_just_pressed("left_click"):
				inventoryUI.select_slot(self)
		if Input.is_action_just_pressed("right_click"):
				inventoryUI.split_stack(self)

func lock():
	isLocked = true
	slot.texture = lockedSprite
	set_quantity(0)

func unlocked():
	isLocked = false
	slot.texture = unlockedSprite

func set_item(item:Item, quantity:int = 1) -> void:
	print(quantity)
	if not isLocked:
		self.item = item
		if not item:
			quantity = 0
		set_quantity(quantity)
		set_texture()

func set_empty():
	self.item = null
	set_quantity(0)
	set_texture()

func set_quantity(new_quantity: int):
	if not pickedUp:
		self.quantity = new_quantity
		
		if not visualQuantity == 0 and visualQuantity < self.quantity:
			if visualQuantity <= 1:
				quantity_text.visible = false
			else:
				quantity_text.visible = true
				quantity_text.text = "%s" % visualQuantity
		else:
			if quantity <= 1:
				quantity_text.visible = false
			else:
				quantity_text.visible = true
				quantity_text.text = "%s" % quantity

func set_texture():
	if not pickedUp:
		if item:
			slot.texture = withItemSprite
			itemSprite.texture = item.sprite
		else:
			slot.texture = unlockedSprite
			itemSprite.texture = null

func picked_up(newQuantity: int, heldQuantity: int):
	if visualQuantity == 0:
		visualQuantity = quantity - newQuantity
	else:
		visualQuantity -= newQuantity
	
	itemSprite.texture = null
	if visualQuantity == 0:
		quantity_text.text = ""
	else:
		quantity_text.text = str(quantity - newQuantity)
	slot.texture = unlockedSprite
	
	if visualQuantity == 0:
		pickedUp = true

func put_down():
	pickedUp = false
	visualQuantity = 0

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false

