extends "res://PathingEntity.gd"
onready var timer : Timer = $PathingTimer
onready var nav_2d : Navigation2D = get_node("/root/GameScene/Navigation2D")
onready var character : KinematicBody2D = get_node("/root/GameScene/YSort/Player")
onready var flockingArea : Area2D = $FlockingArea
onready var targetIcon : Sprite = $TargetIcon
onready var attackTimer : Timer = $AttackTimer;
onready var gameScene = get_node("/root/GameScene")
var thresholdDistance : float = 17.0
var flockForce : float = 5
var xpToGive : = 2
var attackStarted : = false

var damageText = preload("res://DamageText.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	attackTimer.connect("timeout",self,"_check_attack") 
	speed = 10.0
	timer.wait_time = 0.5
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.start() #to start
	targetIcon.visible = false
	._ready();
	
func _physics_process(delta):
	var attackVector = global_position - character.global_position
	if !attackStarted:
		if attackVector.length() < attackRange:
			attackStarted = true
			attackTimer.start()
	else: 
		if attackVector.length() > attackRange:
			attackStarted = false
			attackTimer.stop()
			
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
	
func _check_attack():
	var attackVector = global_position - character.global_position
	
	if attackVector.length() < attackRange:
		var damage = damageText.instance()
		damage.position = character.global_position + Vector2(0, -16)
		damage.amount = roll_damage()
		gameScene.call_deferred("add_child", damage)

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
