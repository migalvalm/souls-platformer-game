extends Node

onready var audioPlayers = get_node("AudioPlayers")

func play_sound(sound) -> void:
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
