extends Control
class_name InventoryContainer

onready var slot_container: GridContainer = get_node("VContainer/Background/GridContainer")
onready var animation: AnimationPlayer = get_node("Animation")

var current_state: String
var can_click: bool = false
var is_visible: bool = false

var stackable_item_types = ["Resource", "Health", "Mana"]

var item_index: int

var slot_list: Array = [
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"",
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"",
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"",
]
var slot_item_info: Array = [
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"",
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"",
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"", 
	"",
]

func _ready() -> void:
	for children in slot_container.get_children():
		children.connect("empty_slot", self, "empty_slot")

func update_slot(item_name: String, item_image: StreamTexture, item_info: Array)-> void:
	if aggregate_item_search(item_name, item_image, item_info):
		return
		
	for index in slot_container.get_child_count():
		var slot: TextureRect = slot_container.get_child(index)
		if slot.item_name == "":
			slot_list[index] = item_name
			slot_item_info[index] = [item_name, item_image, item_info]
			slot.update_item(item_name, item_image, item_info)
			return

func empty_slot(index: int) -> void:
	slot_list[index] = ""
	slot_item_info[index] = ""

#Helpers
func aggregate_item_search(item_name: String, item_image: StreamTexture, item_info: Array) -> bool:
	var existing_item_index: int = slot_list.find(item_name)
	if existing_item_index != -1:
		if allocate_slot(existing_item_index, item_name, item_image, item_info):
			return true
		
	var aux_item_index: int = slot_list.find_last(item_name)
	if aux_item_index != -1:
		if allocate_slot(aux_item_index, item_name, item_image, item_info):
			return true

	return false

func allocate_slot(item_index: int, item_name: String, item_image: StreamTexture, item_info: Array) -> bool:
	var item_slot: TextureRect = slot_container.get_child(item_index)
		
	if item_slot.amount < 9 and stackable_item_types.has(item_slot.item_type):
		var current_amount: int = item_slot.amount + item_info[4]
		
		if current_amount > 9:
			var leftover: int = current_amount - 9
			item_info[3] = 9 - item_slot.amount
			item_slot.update_item(item_name, item_image, item_info)
			
			item_info[3] = leftover
			update_slot(item_name, item_image, item_info)
			return true
			
		item_slot.update_item(item_name, item_image, item_info)
		return true
		
	return false
