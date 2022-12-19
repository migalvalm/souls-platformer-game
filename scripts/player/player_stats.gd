extends Node
class_name PlayerStats

#####
# Refactor Idea: Turn all type of state managements on their own classes (ex: HealthState), inside of this
# Reference: https://www.reddit.com/r/godot/comments/5c3qq5/comment/d9tf3w5/?utm_source=reddit&utm_medium=web2x&context=3
#####

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var collision_area = get_node(collision_area) as Area2D

onready var invencibility_timer: Timer = get_node("InvencibilityTimer")

var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 1
var base_magic_attack: int =3
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0 
var bonus_magic_attack: int = 0
var bonus_defense: int = 0

var current_mana: int
var current_health: int

var max_mana: int
var max_health: int

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	"1": 25,
	"2": 33,
	"3": 49,
	"4": 66,
	"5": 93,
	"6": 135,
	"7": 186,
	"8": 251,
	"9": 356,
}


func _ready() -> void:
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
	current_health = base_health + bonus_health
	max_health = current_health
	
# Level State Management
func update_exp(value: int) -> void:
	current_exp += value
	if current_exp >=  get_current_level_max_xp() and level < 9:
		var leftover: int = current_exp - get_current_level_max_xp()
		current_exp = leftover
		on_level_up()
		level += 1
	elif current_exp >= get_current_level_max_xp() and level == 9:
		current_exp = get_current_level_max_xp()

func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health

func get_current_level_max_xp() -> int:
	return level_dict[str(level)]

# Health State Management
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			if current_health >= max_health:
				current_health = max_health
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				player.dead = true
			else:
				player.on_hit = true
				player.attacking = false

func verify_shield(value: int) -> void:
	if player.defending: 
		if (base_defense + bonus_defense) >= value:
			return 
		
		var damage = abs((base_defense + bonus_defense) - value)
		current_health -= damage
		
	else:
		current_health -= value

# Mana State Management
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			if current_mana >= max_mana:
				current_health = max_mana
		"Decrease":
			current_mana -= value

# Helpers
func player_attack() -> int:
	return base_attack + bonus_attack

# Signals
func on_collision_area_entered(area):
	if area.name == "EnemyAttackArea":
		update_health("Decrease", area.damage)
		collision_area.set_deferred("monitoring", false)
		invencibility_timer.start(area.invencibility_timer)

func on_invencibility_timer_timeout() -> void:
	collision_area.set_deferred("monitoring", true)
