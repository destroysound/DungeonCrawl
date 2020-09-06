extends KinematicBody2D

var curHp : int = 7
var maxHp : int = 10
var damage : = 5
var attackRate : = 10.0
var attackRange : = 20

func take_damage (dmgToTake):
	curHp -= dmgToTake
	if curHp <= 0:
		die()
		
func die():
	pass
