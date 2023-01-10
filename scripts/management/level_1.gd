extends Level
class_name LevelOne

onready var level_song = preload('res://assets/sounds/NDKG_CreepyAtmosphere_Looped.wav')

func _ready():
	SoundPlayer.play_sound(level_song)
