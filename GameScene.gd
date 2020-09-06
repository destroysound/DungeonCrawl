extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var character : KinematicBody2D = $YSort/Player
onready var line_2d : Line2D = $Line2D
var pathingTimer
var pathing : bool = false
var wasPathing: bool = false

func _process(delta):
	OS.set_window_title(" fps: " + str(Engine.get_frames_per_second()))

func _ready():
	pathingTimer = Timer.new()
	add_child(pathingTimer)
	pathingTimer.autostart = false
	pathingTimer.wait_time = 0.1
	pathingTimer.connect("timeout", self, "_find_path")

	#OS.set_window_size(Vector2(1280, 800))
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index == BUTTON_LEFT and event.pressed and !character.dashing:
		pathing = true
		pathingTimer.start()
		_find_path()
	if event.button_index == BUTTON_LEFT and !event.pressed and !character.dashing:
		pathing = false
		pathingTimer.stop()
	if event.button_index == BUTTON_RIGHT and event.pressed and !character.dashing and !character.dashPrep:
		character.prep_dash()
	if event.button_index == BUTTON_RIGHT and !event.pressed and !character.dashing and character.dashPrep:
		wasPathing = pathing
		pathing = false
		pathingTimer.stop()
		character.begin_dash(get_global_mouse_position())

func _find_path():
	if (pathing):
		var new_path : = nav_2d.get_simple_path(character.global_position, get_global_mouse_position(), false)
		character.path = new_path
		character.deselect_enemy()
		line_2d.points = new_path

func restore_pathing():
	if (wasPathing):
		pathingTimer.start()
		pathing = true
		_find_path()
