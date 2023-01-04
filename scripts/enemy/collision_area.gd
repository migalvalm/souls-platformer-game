extends Area2D
class_name CollisionArea

onready var timer: Timer = get_node("Timer")

export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D
export(NodePath) onready var enemy_bar = get_node(enemy_bar) as Control

export(int) var health
export(float) var invulnerability_timer

func _ready() -> void:
	enemy_bar.init_bar(health)

func update_health(damage: int) -> void:
	health -= damage
	enemy_bar.update_bar(health)
	enemy.spawn_floating_text("-", "Damage", damage)
	
	if health <= 0: enemy.can_die = true
	else: enemy.can_hit = true

# Signals
func on_collision_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		 var player_stats: Node = area.get_parent().get_node("Stats")
		 var player_attack: int = player_stats.player_attack()
		 update_health(player_attack)
	elif area is FireSpell:
		update_health(area.spell_damage)
		set_deferred("monitoring", false)
		timer.start(invulnerability_timer)

func on_timer_timeout() -> void:
		set_deferred("monitoring", true)
