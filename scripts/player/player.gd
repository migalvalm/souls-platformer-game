extends KinematicBody2D
class_name Player

const SPELL: PackedScene = preload("res://scenes/player/spell_area.tscn")
onready var player_sprite: Sprite = get_node("Texture")
onready var wall_ray: RayCast2D = get_node("WallRay")
onready var stats: Node = get_node("Stats")
onready var player_dash = get_node("PlayerDash")

var direction: int = 1
var velocity: Vector2
var spell_offset: Vector2 = Vector2(100, -50)
var jump_count: int = 0
var roll_count: int = 0

#States
var on_hit: bool = false
var dead: bool = false
var dashing: bool = false
var landing: bool = false
var on_wall: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var rolling: bool = false
var standing_up: bool = false

var flipped: bool = false
var not_on_wall: bool = true
var can_track_input: bool = true

export(int) var speed
export(int) var jump_speed
export(int) var double_jump_speed
export(int) var roll_speed
export(int) var dash_speed
export(float) var dash_length
export(int) var wall_jump_speed

export(int) var wall_gravity
export(int) var player_gravity
export(int) var wall_impulse_speed
export(int) var magic_attack_cost

func _ready():
	#TODO Find out why collision shape begins enabled and as a square (This one is only touched in the Animation node)
	#so... Hammer Time
	#When rendered player attack area starts disabled
	$AttackArea.get_node("Collision").set_deferred("disabled", true)

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	physics_env(delta)
	
func physics_env(delta: float) -> void:
	gravity(delta)
	
	if dashing:
		velocity.x = dash_speed * direction
		velocity = move_and_slide(velocity, Vector2.UP)
	else:
		velocity = move_and_slide(velocity, Vector2.UP)
	
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	if can_move():
		velocity.x = get_input_direction() * speed
		return
		
	velocity.x = 0

func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall(): 
		jump_count = 0
		
	if Input.is_action_just_pressed("jump") and jump_count < 2 and can_move():
		jump_count += 1

		spawn_effect("res://scenes/effect/dust/jump.tscn", Vector2(0,30), is_flipped())
		if next_to_wall() and not is_on_floor():	
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			if jump_count == 1:
				velocity.y = jump_speed
			elif jump_count == 2:
				velocity.y += double_jump_speed
	

func actions_env() -> void:
	if rolling:
		roll()
		return
		
	dash()
	attack()
	crouch()
	#defense()

func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending and is_on_floor()
	var combo_condition: bool = attacking and not crouching and not defending and is_on_floor()
	var crouch_attack_condition: bool = not attacking and crouching and not defending and is_on_floor()
	
	if Input.is_action_just_pressed("attack") and attack_condition:
		attacking = true
		player_sprite.normal_attack = true
	
	elif Input.is_action_just_pressed("attack") and combo_condition:
		player_sprite.normal_attack_2 = true
		
	elif Input.is_action_just_pressed("attack") and crouch_attack_condition:
		attacking = true
		player_sprite.crouch_attack = true
	
#	elif Input.is_action_just_pressed("magic_attack") and attack_condition and stats.current_mana >= magic_attack_cost:
	#   attacking = true
	#   player_sprite.magic_attack = true
	#   stats.update_mana("Decrease", magic_attack_cost)
	

func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
		
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouching_off = true
	
	if Input.is_action_just_released("crouch") and crouching:
		crouching = false
		standing_up = true
		can_track_input = true

func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
		
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true
		
func roll() -> void:
	if get_input_direction() != 0:
		velocity.x = get_input_direction() * roll_speed 
	else:
		velocity.x = roll_speed * direction

func dash() -> void:
	var dash_condition: bool = not attacking and not dashing and not rolling and player_dash.dash_count > 0
	if Input.is_action_pressed("roll") and dash_condition:
		player_dash.start_dash(player_sprite, dash_length)
		dashing = true
		
		player_dash.spawn_dash_ghost()
		player_dash.spawn_dash_effect(Vector2(10 * direction,20), is_flipped())
		

func can_move() -> bool:
	return can_track_input and not attacking

func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity + 40
	else:
		velocity.y += delta * player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity

func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
	else:
		not_on_wall = true
		
	return !not_on_wall

func spawn_effect(effect_path: String, offset: Vector2, is_flipped: bool) -> void:
	var effect_instance: EffectTemplate = load(effect_path).instance()
	
	get_tree().root.call_deferred("add_child", effect_instance)
	
	if is_flipped:
		effect_instance.flip_h = true
	
	effect_instance.global_position = global_position + offset
	effect_instance.play_effect()

func spawn_spell() -> void:
	var spell: FireSpell = SPELL.instance()
	spell.spell_damage = stats.base_magic_attack + stats.bonus_magic_attack
	spell.global_position = global_position + spell_offset
	
	get_tree().root.call_deferred("add_child", spell)

func is_damaged() -> bool:
	return on_hit or dead

# If player is right returns true, if left returns true
func is_flipped() -> bool:
	if direction > 0: return false
	
	return true

func get_input_direction() -> float:
	return  Input.get_axis("left", "right")

