extends Node2D
class_name DamageText

onready var label = $Label
onready var critLabel = $CritLabel
onready var animationPlayer = $AnimationPlayer
var amount : int = 0
var hideTimer
var critted : = false

func _ready():
	label.text = String(amount)
	critLabel.text = String(amount)
	animationPlayer.play("Fadeout")
	hideTimer = Timer.new()
	add_child(hideTimer)
	hideTimer.autostart = true
	hideTimer.wait_time = 1.60
	hideTimer.connect("timeout", self, "_hide_timeout")
	hideTimer.start()
	if critted:
		label.visible = false
		critLabel.visible = true

func _process(_delta):
	position -= Vector2(0, 0.3)

func _hide_timeout():
	queue_free()
