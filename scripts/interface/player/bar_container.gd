extends Control
class_name BarContainer

onready var tween: Tween = get_node("Tween")

onready var health_bar: TextureProgress = get_node("HealthBarBackground/HealthBar")
onready var mana_bar: TextureProgress = get_node("ManaBarBackground/ManaBar")
onready var exp_bar: TextureProgress = get_node("ExpBarBackground/ExpBar")

var current_exp: int
var current_mana: int
var current_health: int

func init_bar(health: int, mana: int, max_exp_value: int) -> void:
	exp_bar.max_value = max_exp_value
	health_bar.max_value = health
	mana_bar.max_value = mana

	health_bar.value = health
	mana_bar.value = mana
	exp_bar.value = 0
	
	current_exp = 0
	current_mana = mana
	current_health = health

func increase_max_value(type: String, max_value: int, value: int) -> void:
	match type:
		"Health":
			health_bar.max_value = max_value
			health_bar.value = value
			current_health = value
		"Mana":
			mana_bar.max_value = max_value
			mana_bar.value = value
			current_mana = value

func update_bar(type: String, value: int) -> void:

	match type:
		"HealthBar":
			call_tween(health_bar, current_health, value)
			current_health = value
		"ManaBar":
			call_tween(mana_bar, current_mana, value)
			current_mana = value
		"ExpBar":
			call_tween(exp_bar, current_exp, value)
			current_exp = value

# Helpers
func reset_exp_bar(max_exp: int, value: int) -> void:
	exp_bar.max_value = max_exp
	exp_bar.value = value
	current_exp = value
	
	call_tween(
		exp_bar,
		0,
		current_exp
	)
	
func call_tween(bar: TextureProgress, initial_value: int, final_value: int) -> void:
	var _interpolate_value: bool = tween.interpolate_property(
		bar,
		"value",
		initial_value,
		final_value,
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
