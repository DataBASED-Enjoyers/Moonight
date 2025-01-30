# systems/EntityFactory.gd
class_name EntityFactory extends Node

static func create_entity(data: EntityData) -> Entity:
	var new_entity = load("res://entities/entity.tscn").instantiate()
	new_entity.entity_data = data
	new_entity.components = _get_required_components(data)
	return new_entity

static func _get_required_components(data: EntityData) -> Array[String]:
	var components = ["Health"]
	
	if data.speed > 0:
		components.append("Movement")
	if data.base_damage > 0:
		components.append("Combat")
	
	return components
