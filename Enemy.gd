extends "res://PathingEntity.gd"
onready var timer : Timer = $PathingTimer
onready var nav_2d : Navigation2D = get_node("/root/GameScene/Navigation2D")
onready var character : KinematicBody2D = get_node("/root/GameScene/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 10.0
	timer.connect("timeout",self,"_on_timer_timeout") 
#timeout is what says in docs, in signals
#self is who respond to the callback
#_on_timer_timeout is the callback, can have any name
	timer.start() #to start
	
func _on_timer_timeout():
	var new_path : = nav_2d.get_simple_path(global_position, character.global_position)
	set_path(new_path)
	print (new_path)
