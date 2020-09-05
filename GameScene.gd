extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var character : KinematicBody2D = $Player
onready var line_2d : Line2D = $Line2D
onready var camera : Camera2D = get_node("Player/Camera")

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return

	var new_path : = nav_2d.get_simple_path(character.global_position, get_global_mouse_position())
	character.path = new_path
	line_2d.points = new_path
