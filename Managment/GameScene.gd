extends Node2D

signal player_initialised

onready var nav_2d : Navigation2D = $Navigation2D
onready var character : KinematicBody2D = $YSort/Player
onready var line_2d : Line2D = $Line2D
var pathingTimer
var pathing : bool = false
var wasPathing: bool = false

func _process(delta):
	if not character:
		initialise_player()
		return
	OS.set_window_title(" fps: " + str(Engine.get_frames_per_second()))

func _ready():
	pathingTimer = Timer.new()
	add_child(pathingTimer)
	pathingTimer.autostart = false
	pathingTimer.wait_time = 0.1
	pathingTimer.connect("timeout", self, "_find_path")

	#OS.set_window_size(Vector2(1280, 800))
	pass
	
func initialise_player():
	character = get_tree().get_root().get_node("/root/GameScene/YSort/Player")
	if not character:
		return
	
	emit_signal("player_initialised", character)
	
	character.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
	var existing_inventory = load("user://inventory.tres")
	if existing_inventory:
		character.inventory.set_items(existing_inventory.get_items())
	else:
		#give player 3 potions
		character.inventory.add_items("Potion", 3)

func _on_player_inventory_changed(inventory):
	ResourceSaver.save("user://inventory.tres", inventory)

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if character.dashing:
		return
		
	if event.button_index == BUTTON_LEFT and event.pressed:
		character.deselect_enemy()
		pathing = true
		pathingTimer.start()
		_find_path()
	if event.button_index == BUTTON_LEFT and !event.pressed:
		pathing = false
		if !character.selectedEnemy:
			pathingTimer.stop()
	if event.button_index == BUTTON_RIGHT and event.pressed and !character.dashPrep:
		character.prep_dash()
	if event.button_index == BUTTON_RIGHT and !event.pressed and character.dashPrep:
		wasPathing = pathing
		pathing = false
		pathingTimer.stop()
		character.deselect_enemy()
		character.begin_dash(get_global_mouse_position())

func _find_path():
	if pathing or character.selectedEnemy:
		var target = get_global_mouse_position()
		if (character.selectedEnemy):
			target = character.selectedEnemy.global_position
		var new_path : = nav_2d.get_simple_path(character.global_position, target, false)
		character.path = new_path
		line_2d.points = new_path

func restore_pathing():
	if (wasPathing):
		pathingTimer.start()
		pathing = true
		_find_path()
