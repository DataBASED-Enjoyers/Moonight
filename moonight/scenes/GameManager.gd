extends Node

# Singleton pattern using autoload
@export var main_menu_scene: String = "res://scenes/MainMenu.tscn"
@export var overworld_scene: String = "res://scenes/Overworld.tscn"

# Signals
signal scene_changed(new_scene)

# Game state variables
var current_scene: String = ""
var current_scene_name: String = ""
var player_data: Dictionary = {}

func _ready():
	print("Game Manager ready!")
	pass	
	
func start_run():
	change_scene("Overworld", overworld_scene)
	
func quit_game():
	get_tree().quit()

# Change scene method
func change_scene(scene_name: String, scene_file: String):
	
	current_scene_name = scene_name
	current_scene = scene_file
	get_tree().change_scene_to_file(scene_file)
	
	emit_signal("scene_changed", current_scene)

# Save game state
func save_game_state() -> void:
	# Serialize player data and other game state info
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_data))
		file.close()

# Load game state
func load_game_state() -> void:
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		if file:
			var json = JSON.new()
			var data = json.parse(file.get_as_text())
			file.close()
			player_data = data
	else:
		print("No saved game found.")

# Add more methods for additional features as needed
