extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var character : KinematicBody2D = $YSort/Player
onready var line_2d : Line2D = $Line2D

func _process(delta):
	OS.set_window_title(" fps: " + str(Engine.get_frames_per_second()))

func _ready():
	#OS.set_window_size(Vector2(1280, 800))
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index == BUTTON_LEFT and event.pressed and !character.dashing:
		var new_path : = nav_2d.get_simple_path(character.global_position, get_global_mouse_position(), false)
		character.path = new_path
		character.deselect_enemy()
		line_2d.points = new_path
	if event.button_index == BUTTON_RIGHT and event.pressed:
		character.begin_dash(get_global_mouse_position())
