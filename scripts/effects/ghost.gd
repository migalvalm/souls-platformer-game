extends Sprite
class_name Ghost

onready var tween: Tween = get_node("Tween")

func _ready():
	single_shadow_spawn()
	tween.start()
	

func on_tween_completed(object: Object, key: NodePath) -> void:
	queue_free()

# Types of shadow casting
func single_shadow_spawn():
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.8, 3, 1)
	tween.start()
