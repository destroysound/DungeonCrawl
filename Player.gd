extends KinematicBody2D

var speed : = 150.0
var path : = PoolVector2Array() setget set_path

onready var animator : AnimatedSprite = get_node("AnimatedSprite")


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	var move_distance : = speed * delta
	move_along_path(move_distance)


func move_along_path(distance : float) -> void:
	var last_point : = position
	for index in range(path.size()):
		var distance_to_next = last_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = last_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif path.size() == 1 and distance >= distance_to_next:
			position = path[0]
			set_process(false)
			break

		distance -= distance_to_next
		last_point = path[0]
		path.remove(0)


func set_path(value : PoolVector2Array) -> void:
	if value.size() == 0:
		return
	path = value
	path.remove(0)
	set_process(true)
	
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
			print("West")
		1:
			animator.play("walk_up")
			print("North")
		2:
			animator.play("walk_right")
			print("East")
		3:
			animator.play("walk_down")
			print("South")

	# Remember our current position for next frame
	_position_last_frame = position
