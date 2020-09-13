extends GridContainer

onready var gameScene = $"/root/GameScene"

func _ready():
	gameScene.connect("player_initialised", self, "_on_player_initialised")

func _on_player_initialised(player):
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")

func _on_player_inventory_changed(inventory):
	for n in get_children():
		n.queue_free()
	
	for item in inventory.get_items():
		var item_label = Label.new()
		item_label.text = "%s * %d" % [item.item_reference.name, item.quantity]
		add_child(item_label)
