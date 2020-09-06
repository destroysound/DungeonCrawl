extends "res://PathingEntity.gd"
onready var ui = get_node("/root/GameScene/CanvasLayer/UI")
onready var rayCast = get_node("RayCast2D")
onready var line2d = get_node("/root/GameScene/Line2D")
onready var skillshot = get_node("/root/GameScene/Skillshot")
onready var weapon : Area2D = $Weapon;
onready var weaponCollider : CollisionShape2D = $Weapon/WeaponCollider;
onready var attackTimer : Timer = $AttackTimer;
onready var gameScene = get_node("/root/GameScene")
var curLevel : int = 0
var curXp : int = 0
var xpToNextLevel : int = 50
var xpToLevelIncreaseRate : float = 1.2
var selectedEnemy = null
var dashClickPosition = null
var dashPosition = null
var dashPrep = false
var dashing = false
var dashLength = 100

func _ready ():
	ui.update_level_text(curLevel)
	ui.update_health_bar(curHp, maxHp)
	ui.update_xp_bar(curXp,xpToNextLevel)
	attackTimer.connect("timeout",self,"_check_attack") 
	attackTimer.start()


func _physics_process(delta):
	if dashing:
		if (!dashPosition):
			dashPosition = calculate_skillshot_vector(dashClickPosition)
			line2d.points = [position, dashPosition]
		
		# now we have a dash position, so we can dash
		velocity = (dashPosition - position).normalized() * speed * 4
		velocity = move_and_slide(velocity)

		if (get_slide_count()):
			stop_dash()
		elif ((dashPosition - position).length() < 2):
			stop_dash()
			
	else:
		if dashPrep:
			dashPosition = calculate_skillshot_vector(get_global_mouse_position())
			skillshot.points = [position, dashPosition]			
		._physics_process(delta)

func _check_attack():
	if !selectedEnemy:
		return
		
	var attackVector = global_position - selectedEnemy.global_position
	
	if attackVector.length() < attackRange:
		var damage = DamageText.new()
		damage.position = global_position
		gameScene.call_deferred("add_child", damage)
		var cardinal_direction = int(4.0 * (attackVector.rotated(PI / 4.0).angle() + PI) / TAU)
		match cardinal_direction:
			0:
				animator.play("attack_right")
			1:
				animator.play("attack_down")
			2:
				animator.play("attack_left")
			3:
				animator.play("attack_up")

func calculate_skillshot_vector(target):
	var dashVector = (global_position - target).normalized() * dashLength

	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, global_position - dashVector, [self], 0b101)
	if (result):
		# we hit something, so dash there
		return result.position
	else:
		return global_position - dashVector

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
	.take_damage(dmgToTake)
	ui.update_health_bar(curHp, maxHp)

func select_enemy(enemy):
	if selectedEnemy:
		selectedEnemy.deselect()
	selectedEnemy = enemy

func deselect_enemy():
	if selectedEnemy:
		selectedEnemy.deselect()
	selectedEnemy = null

func prep_dash():
	dashPrep = true
	skillshot.visible = true

func begin_dash(position):
	dashPrep = false
	skillshot.visible = false
	path = []
	set_collision_mask_bit(1, false)
	dashClickPosition = position
	dashPosition = null
	dashing = true
	
func stop_dash():
	dashing = false;
	set_collision_mask_bit(1, true)
	dashClickPosition = null
	dashPosition = null
	gameScene.restore_pathing()
