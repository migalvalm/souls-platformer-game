extends KinematicBody2D
class_name Player

onready var player_sprite: Sprite = get_node("Texture")
onready var wall_ray: RayCast2D = get_node("WallRay")
onready var stats: Node = get_node("Stats")

var direction: int = -1
var velocity: Vector2
var jump_count: int = 0

#States
var on_hit: bool = false
var dead: bool = false
var landing: bool = false
var on_wall: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var flipped: bool = false
var not_on_wall: bool = true
var can_track_input: bool = true

export(int) var speed
export(int) var jump_speed
export(int) var wall_jump_speed

export(int) var wall_gravity
export(int) var player_gravity
export(int) var wall_impulse_speed

func _ready():
	#TODO Find out why collision shape begins enabled and as a square (This one is only touched in the Animation node)
	#so... Hammer Time
	#When rendered player attack area starts disabled
	$AttackArea.get_node("Collision").set_deferred("disabled", true)

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
	gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if can_move():
		velocity.x = input_direction * speed
		return
		
	velocity.x = 0

func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall(): 
		jump_count = 0

	if Input.is_action_just_pressed("jump") and jump_count < 2 and can_move():
		jump_count += 1

		spawn_effect("res://scenes/effect/dust/jump.tscn", Vector2(0,18), is_flipped())
		if next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			velocity.y = jump_speed

func actions_env() -> void:
	attack()
	crouch()
	defense()

func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending 
	
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor() and not defending:
		attacking = true
		player_sprite.normal_attack = true

func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
		
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouching_off = true

func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
		
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true

func can_move() -> bool:
	return can_track_input and not attacking

func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = player_gravity
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

func is_damaged() -> bool:
	return on_hit or dead

# If player is right returns false, if left returns true
func is_flipped() -> bool:
	if direction < 0: return false
	
	return true

