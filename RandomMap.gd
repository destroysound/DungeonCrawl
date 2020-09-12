extends TileMap

var room = preload("res://Dungeons/Forest/Room.tscn")
var horizontalHallway = preload("res://Dungeons/Forest/HorizontalHallway.tscn")
onready var navigation : Navigation2D = get_node("/root/GameScene/Navigation2D")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	for i in range(rng.randi_range(5, 10)):
		var newRoom
		if (rng.randi_range(0, 1)):
			newRoom = room.instance()
		else:
			newRoom = horizontalHallway.instance()
		for x in range(-10, 11):
			for y in range(-10, 11):
				var xIndex = x + i * 21
				set_cell(xIndex, y, newRoom.get_cell(x, y))
