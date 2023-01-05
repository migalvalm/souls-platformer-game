extends Sprite
class_name PlayerTexture

signal game_over

var suffix: String = "_right"
var normal_attack: bool = false
var normal_attack_2: bool = false
var crouch_attack: bool = false
var magic_attack: bool = false
var shield_off: bool = false
var crouching_off: bool = false

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D

func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if player.is_damaged():
		hit_behavior()
	elif player.dashing or player.rolling or player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behavior(direction)
	elif direction.y != 0: 
		vertical_behavior(direction)
	elif player.landing == true: 
		animation.play("landing")
	else: 
		horizontal_behavior(direction)

func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
		player.direction = 1
		player.get_node("Collision").position = Vector2(-6.25, 21.25)
		player.get_node("CollisionArea").get_node("Collision").position = Vector2(-6.25, 21.25)
		player.spell_offset = Vector2(100, -50)
		position = Vector2.ZERO
		player.wall_ray.cast_to = Vector2(6, 0)
	
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"
		player.direction = -1
		player.get_node("Collision").position = Vector2(5,21.25)
		player.get_node("CollisionArea").get_node("Collision").position = Vector2(5,21.25)
		position = Vector2(-2, 0)
		player.spell_offset = Vector2(-100, -50)
		player.wall_ray.cast_to = Vector2(-6, 0)
	
func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	if direction.y < 0:
		animation.play("jump")

func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("run" + suffix)
	else:
		animation.play("idle")

func action_behavior(direction: Vector2) -> void:
	if player.rolling:
		animation.play("roll")
	elif player.dashing:
		animation.play("dash")
	elif player.next_to_wall():
		print(direction.y)
		if direction.y < 0:
			animation.play("jump")
		else:
			animation.play("wall_slid")
	elif player.attacking:
		if normal_attack:
			animation.play("attack" + suffix)
		if magic_attack:
			animation.play("spell_attack")
		if crouch_attack:
			animation.play("crouch_attack")
	elif player.defending and shield_off:
		animation.play("shield")
		shield_off = false
	elif player.crouching and crouching_off:
		animation.play("crouch")
		crouching_off = false
	elif player.standing_up:
		animation.play("standing_up")

func hit_behavior() -> void:
	player.set_physics_process(false)
	attack_collision.set_deferred("disabled", true)
	
	if player.dead:
		animation.play("death")
	elif player.on_hit:
		animation.play("hit")

func can_combo():
	if normal_attack_2: 
		animation.play("attack_2" + suffix)
	else:
		player.attacking = false

func _on_animation_finished(anim_name: String):
	match anim_name:
		"landing":
			player.landing = false

		"attack_left":
			normal_attack = false
			
			can_combo()

		"attack_2_left":
			normal_attack_2 = false
			player.attacking = false

		"attack_right":
			normal_attack = false
			
			can_combo()

		"attack_2_right":
			normal_attack_2 = false
			player.attacking = false

		"spell_attack":
			magic_attack = false
			player.attacking = false
			
		"crouch_attack":
			crouch_attack = false
			player.attacking = false
			animation.play("full_crouch")
			
		"standing_up":
			player.standing_up = false
			
		"hit":
			player.on_hit = false
			player.set_physics_process(true)

			if player.defending:
				animation.play("shield")
				
			if player.crouching:
				animation.play("crouch")
			
			if player.rolling:
				player.rolling = false

		"roll":
			player.rolling = false
		
		"dash":
			if player.crouching: animation.play("crouch")
			if player.attacking: player.attacking = false
	
		"death":
			emit_signal("game_over")
