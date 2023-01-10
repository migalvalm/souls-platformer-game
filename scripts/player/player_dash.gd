extends Node2D
class_name DashTimer

var insert_roll: bool = false
var dash_list: Array = []
var dash_count: int = 1

export(PackedScene) var ghost_effect = preload("res://scenes/effect/general_effects/ghost.tscn")
export(NodePath) onready var player = get_node(player) as KinematicBody2D

onready var dash_timer : Timer = $DashTimer
var sprite: Sprite

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("roll") and player.dashing:
		dash_list.append("release")
	
	if Input.is_action_pressed("roll") and dash_list.has("release"):
		player.spawn_effect("res://scenes/effect/dust/roll.tscn", Vector2(0,22), player.is_flipped())
		player.rolling = true
		dash_list = []

func start_dash(sprite: Sprite, dur: float) -> void:
	self.sprite = sprite
	dash_timer.wait_time = dur
	dash_count -= 1
	dash_timer.start()
	

func on_dash_timer_timeout() -> void:
	player.dashing = false
	dash_list = []
	
	yield(
		get_tree().create_timer(0.6),
		"timeout"
	)
	
	dash_count += 1

## Helpers

func spawn_dash_ghost():
	var ghost: Sprite = ghost_effect.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.flip_h = sprite.flip_h

func spawn_dash_effect(offset: Vector2, is_flipped: bool) -> void:
	var effect_instance: EffectTemplate = load("res://scenes/effect/dust/dash.tscn").instance()
	
	get_tree().root.call_deferred("add_child", effect_instance)
	
	effect_instance.flip_v = !is_flipped
	
	effect_instance.global_position = global_position + offset
	effect_instance.play_effect()
