extends "res://PathingEntity.gd"
onready var timer : Timer = $PathingTimer
onready var nav_2d : Navigation2D = get_node("/root/GameScene/Navigation2D")
onready var character : KinematicBody2D = get_node("/root/GameScene/YSort/Player")
onready var flockingArea : Area2D = $FlockingArea
var thresholdDistance : float = 17.0
var flockForce : float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 50.0
	timer.wait_time = 0.1
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.start() #to start
	._ready();
	
func _on_timer_timeout():
	if (engaged):
		return
		
	var distance = global_position - character.global_position
	if (distance.length() > thresholdDistance):
		var new_path : = nav_2d.get_simple_path(global_position, character.global_position, false)
		set_path(new_path)
	else:
		print("stopping")

func _set_velocity_from_path():
	var origVel = ._set_velocity_from_path()
	var enemies_in_flock = flockingArea.get_overlapping_bodies()
	for enemy in enemies_in_flock:
		var flockVel = (enemy.global_position - global_position) * flockForce * speed
		origVel = origVel - flockVel
	return origVel

func _set_engaged(collision):
	if (collision.collider.name == 'Player'):
		set_path([])
		engaged = true
		engagedTimer.start()
