extends Control

onready var number_label = $GUI/HBoxContainer/Bars/LifeBar/Count/Background/Number
onready var bar = $GUI/HBoxContainer/Bars/LifeBar/Gauge
onready var tween = $GUI/HBoxContainer/Bars/LifeBar/Tween
onready var player = $"/root/GameScene/YSort/Player"
var animated_health = 0

func _ready():
	var playerMaxHp = player.maxHp
	bar.max_value = playerMaxHp
	animated_health = player.curHp
	update_health(player.curHp)

func _process(delta):
	var round_value = round(animated_health)
	bar.value = animated_health

func _on_Player_health_changed(curHp, maxHp):
	bar.max_value = maxHp
	number_label.text = str(curHp)
	update_health(curHp)

func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.1)
	if not tween.is_active():
		tween.start()


func _on_Player_died():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0)
