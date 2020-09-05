extends KinematicBody2D

var curHp : int = 10
var maxHp : int = 10
var speed : = 150.0
var damage : = 5
var attackRate : = 10.0
var attackRange : = 5
var path : = PoolVector2Array() setget set_path
var velocity = Vector2()

onready var animator : AnimatedSprite = get_node("AnimatedSprite")
var engagedTimer
var engaged : bool = false

func _ready():
	engagedTimer = Timer.new()
	add_child(engagedTimer)
	engagedTimer.autostart = false
	engagedTimer.wait_time = 0.5
	engagedTimer.connect("timeout", self, "_engaged_timeout")

func set_path(value : PoolVector2Array) -> void:
	if value.size() == 0:
		return
	if (engaged):
		engagedTimer.start()
	path = value
	path.remove(0)
	
var _position_last_frame := Vector2()
var _cardinal_direction = 0

func _physics_process(delta):
	# Get motion vector between previous and current position
	var motion = position - _position_last_frame

	# If the node actually moved, we'll recompute its direction.
	# If it didn't, we'll just the last known one.
	if motion.length() > 0.0001:
		# Now if you want a value between N.S.W.E,
		# you can use the angle of the motion.
		# I came up with this formula last time I needed it:
		_cardinal_direction = int(4.0 * (motion.rotated(PI / 4.0).angle() + PI) / TAU)

	# And now you have it!
	# You can even use it with an array since it's like an index
	match _cardinal_direction:
		0:
			animator.play("walk_left")
		1:
			animator.play("walk_up")
		2:
			animator.play("walk_right")
		3:
			animator.play("walk_down")

	# Remember our current position for next frame
	_position_last_frame = position


	velocity = _set_velocity_from_path()		
	velocity = move_and_slide(velocity)
	
	if (!engaged and get_slide_count() > 0):
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			_set_engaged(collision)

func _set_velocity_from_path():
	if path.size() == 0:
		return Vector2(0, 0)
	var target = path[0]
	if position.distance_to(target) < 2:
		path.remove(0)
		if path.size() == 0:
			return Vector2(0, 0)
		target = path[0]
	return (target - position).normalized() * speed

func _set_engaged(collision):
	path = []
	engaged = true
	engagedTimer.start()

func _engaged_timeout():
	engaged = false
	engagedTimer.stop()
