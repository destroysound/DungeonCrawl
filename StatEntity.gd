extends KinematicBody2D

var curHp : int = 50
var maxHp : int = 50
var damage : = 5
var attackRate : = 10.0
var attackRange : = 20
var attackBase := 5
var attackRandom := 10
var critChance := .5

var rng = RandomNumberGenerator.new()

func roll_damage ():
	var dmgToTake : int = rng.randi_range(1, attackRandom) + attackBase
	var critted : bool = rng.randf_range(0,1) < critChance
	if critted:
		dmgToTake = (rng.randi_range(0, attackRandom-1) + attackBase) * 2
	take_damage(dmgToTake)
	return [dmgToTake, critted]


func take_damage (dmgToTake):
	curHp -= dmgToTake
	if curHp <= 0:
		_die()
		
func _die():
	queue_free()
