extends TileMap

var room = preload("res://Dungeons/Forest/Room.tscn")
var horizontalHallway = preload("res://Dungeons/Forest/HorizontalHallway.tscn")
onready var navigation : Navigation2D = get_node("/root/GameScene/Navigation2D")
var matrix=[]
var width = 0
var height = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	generate_random_dungeon(5, 5, 10)
	
	for x in range(width):
		for y in range(height):
			var room = matrix[x][y]
			if (room):
				copy_cells_from_room(room, x, y)


func copy_cells_from_room(room, tileX, tileY):
	for x in range(-10, 11):
		for y in range(-10, 11):
			var xIndex = x + tileX * 21
			var yIndex = y + tileY * 21
			set_cell(xIndex, yIndex, room.get_cell(x, y))

func generate_random_dungeon(w, h, num_rooms):
	width = w
	height = h
	
	for x in range(width):
		matrix.append([])
		for y in range(height):
			matrix[x].append(null)
	
	for i in range(num_rooms):
		var x = rng.randi_range(0, width-1)
		var y = rng.randi_range(0, height-1)
		var closestRoom = get_closest_room(x, y)
		if (closestRoom[0] != null):
			var distance = sqrt(pow(closestRoom[0] - x, 2) + pow(closestRoom[1] - y, 2))
			if (distance > 1):
				matrix[x][y] = room.instance()
			break
				
		matrix[x][y] = room.instance()
		
	for x in range(width):
		for y in range(height):
			if matrix[x][y]:
				# we want to connect all exits on this room to another room
				var room = get_closest_room(x, y)

func get_closest_room(roomX, roomY):
	var shortestDistance = 10000
	var closestRoomX = null;
	var closestRoomY = null;
	
	for x in range(width):
		for y in range(height):
			if (x == roomX && y == roomY):
				break
			if !matrix[x][y]:
				break
			
			var distance = sqrt(pow(roomX - x, 2) + pow(roomY - y, 2))
			
			if distance < shortestDistance:
				shortestDistance = distance
				closestRoomX = x
				closestRoomY = y
	
	return [closestRoomX, closestRoomY]
