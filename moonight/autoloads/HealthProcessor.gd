# HealthProcessor.gd
extends Node

class EntityHealth:
	var current: int
	var max: int
	
	func _init(p_max: int, p_current: int = -1) -> void:
		max = p_max
		current = p_current if p_current != -1 else p_max

var _entities: Dictionary = {}  # entity_id: EntityHealth

func register_entity(entity_id: String, max_health: int, current_health: int = -1) -> void:
	if _entities.has(entity_id):
		Logger.log("Duplicate entity registration: %s" % entity_id, Logger.LogLevel.WARN)
		return
	
	_entities[entity_id] = EntityHealth.new(max_health, current_health)
	EventBus.emit_signal("entity_registered", entity_id)
	_update_ui(entity_id)

func deregister_entity(entity_id: String) -> void:
	if _entities.erase(entity_id):
		EventBus.emit_signal("entity_deregistered", entity_id)
	else:
		Logger.log("Failed to deregister unknown entity: %s" % \
			entity_id, Logger.LogLevel.WARN)

func apply_damage(
	base_damage: int, 
	target_id: String, 
	source_id: String = "_No Source_" 
	) -> void:
	if not _entities.has(target_id):
		Logger.log("Damage target not found: %s" % target_id, Logger.LogLevel.ERROR)
		return
	
	var final_damage = _calculate_final_value(target_id, base_damage, "damage")
	_entities[target_id].current = clamp(_entities[target_id].current - final_damage, 0, _entities[target_id].max)
	
	EventBus.emit_signal("damage_applied", source_id, target_id, final_damage)
	EventBus.emit_signal("health_changed", target_id, _entities[target_id].current, _entities[target_id].max)
	_update_ui(target_id)
	
	if _entities[target_id].current <= 0:
		_handle_death(target_id)

func apply_healing(
	base_healing: int, 
	target_id: String, 
	source_id: String = "_No Source_" 
	) -> void:
	if not _entities.has(target_id):
		Logger.log("Healing target not found: %s" % target_id, Logger.LogLevel.ERROR)
		return
	
	var final_healing = _calculate_final_value(target_id, base_healing, "heal")
	_entities[target_id].current = clamp(_entities[target_id].current + final_healing, 0, _entities[target_id].max)
	
	EventBus.emit_signal("healing_applied", source_id, target_id, final_healing)
	EventBus.emit_signal("health_changed", target_id, _entities[target_id].current, _entities[target_id].max)
	_update_ui(target_id)

func _calculate_final_value(entity_id: String, base_value: int, effect_type: String) -> int:
	var request := StatusEffectRequest.new(entity_id, base_value, effect_type)
	EventBus.emit_signal("status_effect_requested", request)
	return request.final_value

func _handle_death(entity_id: String) -> void:
	EventBus.emit_signal("entity_died", entity_id)
	deregister_entity(entity_id)

func _update_ui(entity_id: String) -> void:
	var health = _entities[entity_id]
	EventBus.emit_signal("health_updated", entity_id, health.current, health.max)

class StatusEffectRequest:
	var entity_id: String
	var base_value: int
	var effect_type: String
	var final_value: int
	
	func _init(p_entity_id: String, p_base_value: int, p_effect_type: String) -> void:
		entity_id = p_entity_id
		base_value = p_base_value
		effect_type = p_effect_type
		final_value = p_base_value
