extends CanvasLayer

onready var inventory: Control = get_node("InventoryContainer")

func _process(delta: float) -> void:
	show_inventory()
	
func show_inventory() -> void:
	if Input.is_action_just_pressed("inventory"):
		if inventory.is_visible:
			inventory.is_visible = false
			inventory.animation.play("hide_container")
			return
		else:
			inventory.is_visible = true
			inventory.animation.play("show_container")
			return
