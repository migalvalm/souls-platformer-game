extends Control
class_name EnemyHealthBar

onready var tween: Tween = get_node("Tween")
onready var health_bar: TextureProgress = get_node("BarBackground/HealthBar")

var current_health: int

func init_bar(bar_value: int) -> void:
	#Wait for Main Node
	yield(get_parent(), "ready")
	
	health_bar.max_value = bar_value
	health_bar.value = bar_value
	current_health = bar_value

func update_bar(value: int) -> void:
	call_tween(current_health,value)
	current_health = value

func call_tween(old_value: int, new_value: int) -> void:
	var _interpolate_value: bool = tween.interpolate_property(
		health_bar,
		"value",
		old_value,
		new_value,
		0.4,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
