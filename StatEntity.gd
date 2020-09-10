extends KinematicBody2D

var curHp : int = 7
var maxHp : int = 10
var damage : = 5
var attackRate : = 10.0
var attackRange : = 20
var attackBase := 5
var attackRandom := 10
var critChance := .5

var rng = RandomNumberGenerator.new()

func roll_damage ():
	var critted : bool = rng.randf_range(0,1) < critChance
	if critted:
		return [(rng.randi_range(0, attackRandom-1) + attackBase) * 2, critted]
	return [rng.randi_range(0, attackRandom-1) + attackBase, critted]

func take_damage (dmgToTake):
	curHp -= dmgToTake
	if curHp <= 0:
		die()
		
func die():
	pass
