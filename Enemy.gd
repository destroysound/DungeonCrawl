extends "res://PathingEntity.gd"
onready var timer : Timer = $PathingTimer
onready var nav_2d : Navigation2D = get_node("/root/GameScene/Navigation2D")
onready var character : KinematicBody2D = get_node("/root/GameScene/YSort/Player")
onready var flockingArea : Area2D = $FlockingArea
onready var targetIcon : Sprite = $TargetIcon
var thresholdDistance : float = 17.0
var flockForce : float = 5
var xpToGive : = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 10.0
	timer.wait_time = 0.5
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.start() #to start
	targetIcon.visible = false
	._ready();
	
func _physics_process(delta):
	._physics_process(delta)	
	
func _on_timer_timeout():
	if (engaged):
		return

	var distance = global_position - character.global_position
	
	if (distance.length() < attackRange):
		set_path([]);
		
	if (distance.length() > thresholdDistance):
		var new_path : = nav_2d.get_simple_path(global_position, character.global_position, false)
		set_path(new_path)
	else:
		set_path([])

func _set_velocity_from_path():
	var origVel = ._set_velocity_from_path()
	var enemies_in_flock = flockingArea.get_overlapping_bodies()
	for enemy in enemies_in_flock:
		var vector = (enemy.global_position - global_position)
		if (vector.length() > 0):
			var flockNormal = vector.normalized();
			var flockVel = flockNormal * (flockForce / vector.length()) * speed
			origVel = origVel - flockVel
	return origVel

func _set_engaged(collision):
	if (collision.collider.name == 'Player'):
		set_path([])
		engaged = true
		engagedTimer.start()

func deselect():
	targetIcon.visible = false

func _on_ClickableArea_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	character.select_enemy(self)
	targetIcon.visible = true
