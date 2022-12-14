extends Sprite
class_name PlayerTexture

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D

func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if direction.y != 0: vertical_behavior(direction)
	elif player.landing == true: animation.play("landing")
	else: horizontal_behavior(direction)

func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	if direction.y < 0:
		animation.play("jump")
	
func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("run")
	else:
		animation.play("idle")

func _on_animation_finished(anim_name: String):
	pass
