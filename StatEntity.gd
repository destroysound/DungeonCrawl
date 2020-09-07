extends KinematicBody2D

var curHp : int = 7
var maxHp : int = 10
var damage : = 5
var attackRate : = 10.0
var attackRange : = 20
var attackBase := 5
var attackRandom := 10

var rng = RandomNumberGenerator.new()

func roll_damage ():
	return rng.randi_range(0, attackRandom-1) + attackBase

func take_damage (dmgToTake):
	curHp -= dmgToTake
	if curHp <= 0:
		die()
		
func die():
	pass
