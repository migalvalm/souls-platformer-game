extends Area2D
class_name CollisionArea

onready var timer: Timer = get_node("Timer")

export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D
export(int) var health
export(float) var invulnerability_timer

func update_health(damage: int) -> void:
	health -= damage
	print(health)
	if health <= 0: enemy.can_die = true
	else: enemy.can_hit = true

# Signals
func on_collision_area_entered(area: Area2D) -> void:
	print(area.get_parent())
	if area.get_parent() is Player:
		 var player_stats: Node = area.get_parent().get_node("Stats")
		 var player_attack: int = player_stats.player_attack()
		 update_health(player_attack)
	

