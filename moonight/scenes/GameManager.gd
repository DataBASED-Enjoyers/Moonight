# GameManager.gd
extends Node

@export var initial_scene: PackedScene
@export var loading_screen: PackedScene

var _current_scene: Node
var _loading_screen_instance: Node
var _persistent_nodes := []

#region Lifecycle Management
func _ready() -> void:
	EventBus.connect("critical_error", _on_critical_error)
	_load_initial_scene()

func _load_initial_scene() -> void:
	if initial_scene:
		call_deferred("change_scene", initial_scene)
	else:
		EventBus.emit_signal("critical_error", "No initial scene configured in GameManager")

func _on_critical_error(message: String) -> void:
	Logger.log(message, Logger.LogLevel.ERROR)
	# Implement emergency shutdown or recovery logic
#endregion

#region Scene Management
func change_scene(new_scene: PackedScene, persist_current: bool = false) -> void:
	_show_loading_screen()
	
	await get_tree().process_frame
	
	if persist_current and _current_scene:
		_persistent_nodes.append(_current_scene)
		_current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Proper async scene loading
	var loader := ResourceLoader.load_threaded_request(new_scene.resource_path)
	while not ResourceLoader.load_threaded_get_status(loader) == ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
	
	var new_scene_instance = ResourceLoader.load_threaded_get(loader).instantiate()
	get_tree().root.add_child(new_scene_instance)
	
	if _current_scene and not persist_current:
		_current_scene.queue_free()
	
	_current_scene = new_scene_instance
	EventBus.emit_signal("scene_changed", new_scene.resource_path)
	_hide_loading_screen()

func _show_loading_screen() -> void:
	if loading_screen:
		_loading_screen_instance = loading_screen.instantiate()
		get_tree().root.add_child(_loading_screen_instance)

func _hide_loading_screen() -> void:
	if _loading_screen_instance:
		_loading_screen_instance.queue_free()
		_loading_screen_instance = null
#endregion

func quit_game():
	get_tree().quit()

#region Save/Load System
func save_game() -> void:
	var save_data := {
		"scene": _current_scene.scene_file_path if _current_scene else "",
		"persistent_nodes": _persistent_nodes.map(func(n): return n.scene_file_path),
		"player_data": PlayerDataManager.serialize()
	}
	
	ResourceSaver.save(save_data, "user://savegame.tres")
	EventBus.emit_signal("game_saved")

func load_game() -> void:
	if not ResourceLoader.exists("user://savegame.tres"):
		Logger.log("Save file not found", Logger.LogLevel.WARN)
		return
	
	var save_data: Resource = ResourceLoader.load("user://savegame.tres")
	
	# Load persistent nodes
	for scene_path in save_data.persistent_nodes:
		var scene = load(scene_path)
		if scene:
			var instance = scene.instantiate()
			add_child(instance)
			_persistent_nodes.append(instance)
	
	# Load main scene
	if save_data.scene:
		change_scene(load(save_data.scene))
	
	PlayerDataManager.deserialize(save_data.player_data)
	EventBus.emit_signal("game_loaded")
#endregion
