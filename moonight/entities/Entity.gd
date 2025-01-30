# entities/Entity.gd
class_name Entity extends CharacterBody2D

@export var entity_data: EntityData
@export var components: Array[String] = [
	"Health", 
	"Movement",
	"Combat",
	"Animation",
	"HitBox",
	#"StateMachine",
	#"EquipmentSystem"
	]

var _state_machine: Node
var _components: Dictionary = {}

func _ready():
	# Load components
	for component_name in components:
		var component = _create_component(component_name)
		if component:
			add_child(component)
			_components[component_name.to_lower()] = component
	
	# Apply visual configuration
	if entity_data:
		$Sprite2D.texture = entity_data.texture
		$Sprite2D.scale = Vector2.ONE * entity_data.scale
		$Sprite2D.modulate = entity_data.color

func _create_component(component_name: String) -> Node:
	var component_map = {
		"health": HealthComponent,
		"movement": MovementComponent,
		#"combat": preload("res://components/combat_component.gd")
	}
	return component_map.get(component_name.to_lower(), Node).new()

func get_component(component_name: String) -> Variant:
	return _components.get(component_name.to_lower())

func _process(delta):
	if entity_data.ai_behavior:
		entity_data.ai_behavior.update_behavior(delta, self)
