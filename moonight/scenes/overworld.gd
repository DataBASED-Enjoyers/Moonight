extends Node2D

@onready var entrance_scene = preload("res://scenes/Entrance.tscn")
@onready var player_scene = preload("res://scenes/PlayerOverworld.tscn")

# A simple array of dictionaries describing each entrance
var entrance_data_array: Array = [
	{
		"location_name": "Battle Scene A",
		"position": Vector2(400, 200),
		"scene_to_load": "res://scenes/BattleScene.tscn",
		"sprite_texture": preload("res://assets/Sprites/Entrance/portal_small.png")
	},
	{
		"location_name": "Battle Scene B",
		"position": Vector2(700, 300),
		"scene_to_load": "res://scenes/BattleScene.tscn",
		"sprite_texture": preload("res://assets/Sprites/Entrance/portal_small.png")
	}
]

func _ready() -> void:
	print("Overworld: _ready() called.")
	# 1) Spawn the player
	var player = player_scene.instantiate()
	print("Instanced player, name:", player.name)
	player.position = Vector2(100, 100)
	add_child(player)
	
	# 2) Spawn all entrances from the data list
	for data in entrance_data_array:
		print("Spawning entrance for location:", data["location_name"])
		var entrance = entrance_scene.instantiate()
		entrance.location_name = data["location_name"]
		entrance.position = data["position"]
		entrance.scene_to_load = data["scene_to_load"]
		entrance.custom_sprite = data["sprite_texture"]
		add_child(entrance)
