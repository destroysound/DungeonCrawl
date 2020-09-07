extends Node2D
class_name DamageText

onready var label = $Label
onready var animationPlayer = $AnimationPlayer
var amount : int = 0
var hideTimer

func _ready():
	label.text = String(amount)
	animationPlayer.play("Fadeout")
	hideTimer = Timer.new()
	add_child(hideTimer)
	hideTimer.autostart = true
	hideTimer.wait_time = 1.60
	hideTimer.connect("timeout", self, "_hide_timeout")
	hideTimer.start()

func _process(_delta):
	position -= Vector2(0, 0.3)

func _hide_timeout():
	queue_free()
