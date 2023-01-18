extends Control
class_name InventoryContainer

onready var slot_container: GridContainer = get_node("VContainer/Background/GridContainer")
onready var animation: AnimationPlayer = get_node("Animation")
onready var aux_animation: AnimationPlayer = get_node("Container/Animation")
onready var aux_h_container: HBoxContainer = get_node("Container/HContainer") 

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
	for icon in aux_h_container.get_children():
		icon.connect("mouse_exited", self, "mouse_interaction", ["exited", icon])
		icon.connect("mouse_entered", self, "mouse_interaction", ["entered", icon])
		
	for children in slot_container.get_children():
		children.connect("item_clicked", self, "on_item_clicked")
		children.connect("empty_slot", self, "empty_slot")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click and current_state != "":
		match current_state:
			"Equip":
				#TODO
				#slot_container.get_child(item_index).equip_item()
				pass
			"Delete":
				slot_container.get_child(item_index).update_slot()
		item_index = -1
		current_state = ""
		aux_animation.play("hide_container")

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
	# Normal index search from 0...i
	var existing_item_index: int = slot_list.find(item_name)
	if existing_item_index != -1:
		if allocate_slot(existing_item_index, item_name, item_image, item_info):
			return true
	
	# Reverse index search from i...0
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

func reset() -> void:
	item_index = -1
	can_click = false
	current_state = ""
	aux_animation.play("hide_container")
	for children in slot_container.get_children():
		children.reset()

func on_item_clicked(index: int) -> void:
	aux_animation.play("show_container")
	item_index = index
	
	
func mouse_interaction(state: String, object: TextureRect) -> void:
	match state:
		"entered":
			can_click = true
			object.modulate.a = 0.5
			current_state = object.name
			
		"exited":
			can_click = false
			current_state = ""
			object.modulate.a = 1.0
