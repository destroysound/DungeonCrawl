extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var character : KinematicBody2D = $YSort/Player
onready var line_2d : Line2D = $Line2D


func _ready():
	#OS.set_window_size(Vector2(1280, 800))
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return

	var new_path : = nav_2d.get_simple_path(character.global_position, get_global_mouse_position(), false)
	character.path = new_path
	line_2d.points = new_path
