extends Control

onready var life_number_label = $GUI/HBoxContainer/Bars/LifeBar/Count/Background/Number
onready var life_bar = $GUI/HBoxContainer/Bars/LifeBar/Gauge
onready var stamina_number_label = $GUI/HBoxContainer/Bars/EnergyBar/Count/Background/Number
onready var stamina_bar = $GUI/HBoxContainer/Bars/EnergyBar/Gauge
onready var tween = $GUI/HBoxContainer/Bars/Tween

onready var player = $"/root/GameScene/YSort/Player"
var animated_health = 0
var animated_stamina = 0

func _ready():
	var playerMaxHp = player.maxHp
	var playerMaxStamina = player.maxStamina
	life_bar.max_value = playerMaxHp
	stamina_bar.max_value = playerMaxStamina
	animated_health = player.curHp
	animated_stamina = player.curStamina
	update_health(player.curHp)
	update_stamina(player.curStamina)

func _process(delta):
	life_bar.value = animated_health
	stamina_bar.value = animated_stamina

func _on_Player_health_changed(curHp, maxHp):
	life_bar.max_value = maxHp
	life_number_label.text = str(curHp)
	update_health(curHp)

func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.1)
	if not tween.is_active():
		tween.start()


func _on_Player_died():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0)


func _on_Player_stamina_changed(curStamina, maxStamina):
	stamina_bar.max_value = maxStamina
	stamina_number_label.text = str(curStamina)
	update_stamina(curStamina)


func update_stamina(new_value):
	tween.interpolate_property(self, "animated_stamina", animated_stamina, new_value, 0.1)
	if not tween.is_active():
		tween.start()
