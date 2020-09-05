extends "res://PathingEntity.gd"
onready var weapon : Area2D = $Weapon; 
onready var attackTimer : Timer = $AttackTimer;

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
		attackTimer.connect("timeout",self,"_on_timer_timeout") 
		attackTimer.start()

func _on_timer_timeout():
	weapon.hide()
	attackTimer.stop()
