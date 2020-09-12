extends TileMap

export(int, FLAGS, "North", "South", "East", "West") var exitDirections = 0
export(int, FLAGS, "North", "South", "East", "West") var exitsFilled = 0

func is_bit_enabled(mask, index):
	return mask & (1 << index) != 0

func enable_bit(mask, index):
	return mask | (1 << index)

func disable_bit(mask, index):
	return mask & ~(1 << index)
