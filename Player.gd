extends "res://PathingEntity.gd"
onready var ui = get_node("/root/GameScene/CanvasLayer/UI")
onready var rayCast = get_node("RayCast2D") 
onready var weapon : Area2D = $Weapon;
onready var weaponCollider : CollisionShape2D = $Weapon/WeaponCollider;
onready var attackTimer : Timer = $AttackTimer;
var curLevel : int = 0
var curXp : int = 0
var xpToNextLevel : int = 50
var xpToLevelIncreaseRate : float = 1.2

func _ready ():
	ui.update_level_text(curLevel)
	ui.update_health_bar(curHp, maxHp)
	ui.update_xp_bar(curXp,xpToNextLevel)

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

func _set_engaged(collision):
	if (collision.collider.name == 'Enemy'):
		set_path([])
		engaged = true
		engagedTimer.start()

func give_xp (amount):
	curXp += amount
	ui.update_xp_bar(curXp, xpToNextLevel)
	if curXp >= xpToNextLevel:
		level_up()

func level_up ():
	var overflowXp = curXp - xpToNextLevel
	xpToNextLevel *= xpToLevelIncreaseRate
	curXp = overflowXp
	curLevel += 1

	ui.update_xp_bar(curXp, xpToNextLevel)
	ui.update_level_text(curLevel)

func take_damage (dmgToTake):
	curHp -= dmgToTake
	ui.update_health_bar(curHp, maxHp)
	if curHp <= 0:
		die()
		
func die():
	pass
