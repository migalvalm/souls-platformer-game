extends TextureRect
class_name InterfaceItem

signal empty_slot
signal item_clicked

onready var item_texture: TextureRect = get_node("ItemTexture")
onready var item_amount: Label = get_node("Amount")
onready var item_index: int = get_index()

var item_dictionary: Dictionary = {}
var item_name: String = ""
var item_type: String
var item_image_path: String

var type_value: int
var sell_price: int
var amount: int = 0
var can_click: bool = false

var texture_list: Array = [
	"res://assets/interface/inventory/item_background/type_1.png",
	"res://assets/interface/inventory/item_background/type_2.png",
	"res://assets/interface/inventory/item_background/type_3.png",
]

var stackable_item_types = ["Resource", "Health", "Mana"]

func _ready() -> void:
	randomize()
	
	var random_index: int = randi() % texture_list.size()
	texture = load(texture_list[random_index])


func on_item_mouse_entered() -> void:
	can_click = true
	modulate.a = 0.5

func on_item_mouse_exited() -> void:
	can_click = false
	modulate.a = 1.0

func update_item(item: String, item_image: StreamTexture, item_info: Array) -> void:
	item_image_path = item_info[0]
	item_type = item_info[1]
	
	match item_type:
		"Equipment":
			amount = 1
			item_dictionary = item_info[2]
			
		"Weapon":
			amount = 1
			item_dictionary = item_info[2]
			
		"Resource":
			amount += item_info[4]
			type_value = 0
			
		"Health":
			amount += item_info[4]
			type_value = item_info[2]
			
		"Mana":
			amount += item_info[4]
			type_value = item_info[2]
	
	sell_price = item_info[3]
	item_name = item
	item_amount.text = str(amount)
	item_texture.texture = item_image
	
	if amount != 0 and stackable_item_types.has(item_type):
		item_amount.show()
		item_texture.show()
		return
	
	if !stackable_item_types.has(item_type):
		item_texture.show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click and item_name != "":
		emit_signal("item_clicked", item_index)
		
		modulate.a = 0.2
		yield(get_tree().create_timer(0.1), "timeout")
		modulate.a = 0.5
	
func update_slot() -> void:
	clear_item()
	emit_signal("empty_slot", item_index)
	
func update_amount(value: int) -> void:
	var new_amount: int = amount - value
	item_amount.text = str(new_amount)
	amount = new_amount
	
	if new_amount == 0:
		update_slot()
#Helpers
func clear_item():
	item_amount.hide()
	item_texture.hide()
	
	amount = 0
	
	item_name = ""
	item_type = ""
	item_image_path = ""
	
	type_value = 0
	sell_price = 0
