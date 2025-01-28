extends Area2D

@export var location_name: String = "Unnamed Entrance"
@export var scene_to_load: String
@export var custom_sprite: Texture2D
var transition_ready = true

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	if custom_sprite:
		$Sprite2D.texture = custom_sprite

func _on_body_entered(body: Node2D) -> void:
	if transition_ready and body.name == "PlayerOverworld":  # Ensure it's the player
		transition_ready = false  # Lock further transitions
		if scene_to_load:
			print("Player entered %s. Loading scene: %s" % \
				[location_name, scene_to_load])
			call_deferred("_notify_root_for_transition")
		else:
			print("No 'scene_to_load' assigned for %s!" % location_name)
			
func _notify_root_for_transition():
	# Notify GameRoot to handle the transition
	GameManager.change_scene(location_name, scene_to_load)
	transition_ready = true
