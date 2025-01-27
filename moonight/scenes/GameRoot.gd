extends Node
class_name GameRoot

@onready var hud = $HUD

# Scene management
func start_game():
	load_scene("res://scenes/Overworld.tscn")

func load_scene(scene_path: String):
	get_tree().change_scene(scene_path)

# HUD initialization
func initialize_hud():
	hud.update_health(HealthProcessor.get_health("player"), HealthProcessor.get_max_health("player"),
					  HealthProcessor.get_health("buddy"), HealthProcessor.get_max_health("buddy"))
