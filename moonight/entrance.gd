extends Area2D

@export var location_name: String = "Unnamed Entrance"
@export var scene_to_load: String
@export var custom_sprite: Texture2D

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	if custom_sprite:
		$Sprite2D.texture = custom_sprite

func _on_body_entered(body: Node2D) -> void:
	print(body.name)
		# Check if it's the Player that entered the Area
	if body.name == "PlayerOverworld":  
		print("Entered!")
		if scene_to_load:
			# Switch to the specified scene
			get_tree().change_scene_to_file(scene_to_load)
		else:
			print("No 'scene_to_load' assigned for %s!" % location_name)
