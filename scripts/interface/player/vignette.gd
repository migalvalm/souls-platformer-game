extends Control

export(NodePath) onready var player = get_node(player) as KinematicBody2D
onready var vignette: TextureRect = get_node("ColorRect")

