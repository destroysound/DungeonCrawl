extends "res://PathingEntity.gd"
onready var rayCast = get_node("RayCast2D") 
onready var weapon : Area2D = $Weapon;
onready var weaponCollider : CollisionShape2D = $Weapon/WeaponCollider;
onready var attackTimer : Timer = $AttackTimer;
var curLevel : int = 0
var curXp : int = 0
var xpToNextLevel : int = 50
var xpToLevelIncreaseRate : float = 1.2

func _process(delta):
	if (Input.is_action_just_pressed("attack")):
		match _cardinal_direction:
			0:
				weapon.rotation_degrees = 180
			1:
				weapon.rotation_degrees = 270
			2:
				weapon.rotation_degrees = 0
			3:
				weapon.rotation_degrees = 90
		weapon.show()
		weapon.monitoring = true
		attackTimer.connect("timeout",self,"_on_timer_timeout") 
		attackTimer.start()

func _on_timer_timeout():
	weapon.hide()
	weapon.monitoring = false
	attackTimer.stop()

func _on_Weapon_body_entered(body):
	if body.name == "Enemy":
		print("hit"); 
