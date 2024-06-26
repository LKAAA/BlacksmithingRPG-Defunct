extends PanelContainer

class_name Inventory_Slot

var lockedSprite: Texture = preload("res://Assets/Sprites/UI/InventoryLocked.png")
var unlockedSprite: Texture = preload("res://Assets/Sprites/UI/InventorySlot.png")
var withItemSprite: Texture = preload("res://Assets/Sprites/UI/InventorySlotWithItem.png")

var item:Item
var quantity: int

var hovered: bool = false

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
		if Input.is_action_just_pressed("left_click"):
			if item: # If there is an item
				print("Clicked on " + item.name) 
			else:
				print("NO ITEM SAHUSAHDKJSAHDKASUDHSAKJDHSAJKDHSAKJDHASKJDHSAJK")

func lock():
	isLocked = true
	slot.texture = lockedSprite
	set_quantity(0)

func unlocked():
	isLocked = false
	slot.texture = unlockedSprite

func set_item(item:Item, quantity:int = 1) -> void:
	if not isLocked:
		self.item = item
		if not item:
			quantity = 0
		set_quantity(quantity)
		set_texture()

func set_quantity(new_quantity: int):
	self.quantity = new_quantity
	
	if quantity <= 1:
		quantity_text.visible = false
	else:
		quantity_text.visible = true
		quantity_text.text = "%s" % quantity

func set_texture():
	if item:
		slot.texture = withItemSprite
		itemSprite.texture = item.sprite

func _on_mouse_entered():
	print("I was hovered")
	print(isLocked)
	hovered = true

func _on_mouse_exited():
	hovered = false

