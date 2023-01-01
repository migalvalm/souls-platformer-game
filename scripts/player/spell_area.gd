extends Area2D
class_name FireSpell

var spell_damage: int

func _ready() -> void:
	for children in get_children():
		if children is Particles2D and children.name != "ExplosionParticles":
			children.emitting = true

func on_animation_finished(_anim_name: String) -> void:
	queue_free()
