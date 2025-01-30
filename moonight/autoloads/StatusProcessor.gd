extends Node

class StatusEffect:
	var id: String
	var duration: float
	var modifiers: Array  # Array of StatusModifier
	
	func _init(p_id: String, p_duration: float, p_modifiers: Array) -> void:
		id = p_id
		duration = p_duration
		modifiers = p_modifiers

class StatusModifier:
	var effect_type: String  # "damage", "heal", etc.
	var operation: String    # "add", "multiply"
	var value: float
	
	func _init(p_effect_type: String, p_operation: String, p_value: float) -> void:
		effect_type = p_effect_type
		operation = p_operation
		value = p_value

var _entities: Dictionary = {}  # entity_id: Array[StatusEffect]

func _ready() -> void:
	EventBus.connect("status_effect_requested", _on_status_effect_requested)
	EventBus.connect("status_effect_added", _on_status_effect_added)

func register_entity(entity_id: String) -> void:
	if not _entities.has(entity_id):
		_entities[entity_id] = []

func deregister_entity(entity_id: String) -> void:
	_entities.erase(entity_id)

func _on_status_effect_requested(request: HealthProcessor.StatusEffectRequest) -> void:
	if not _entities.has(request.entity_id):
		return
	
	var additive = 0.0
	var multiplicative = 1.0
	
	for effect in _entities[request.entity_id]:
		for modifier in effect.modifiers:
			if modifier.effect_type == request.effect_type or modifier.effect_type == "all":
				match modifier.operation:
					"add": additive += modifier.value
					"multiply": multiplicative *= modifier.value
	
	request.final_value = int((request.base_value + additive) * multiplicative)

func _on_status_effect_added(entity_id: String, effect_id: String, duration: float) -> void:
	if not _entities.has(entity_id):
		Logger.log("Cannot add status to unregistered entity: %s" % entity_id, Logger.LogLevel.WARN)
		return
	
	var effect_def = StatusEffectsDB.get_effect(effect_id)
	if not effect_def:
		Logger.log("Unknown status effect: %s" % effect_id, Logger.LogLevel.ERROR)
		return
	
	var modifiers = []
	for mod in effect_def.modifiers:
		modifiers.append(StatusModifier.new(mod.type, mod.operation, mod.value))
	
	var new_effect = StatusEffect.new(effect_id, duration, modifiers)
	_entities[entity_id].append(new_effect)
	
	if duration > 0:
		get_tree().create_timer(duration).connect("timeout", _remove_effect.bind(entity_id, new_effect))

func _remove_effect(entity_id: String, effect: StatusEffect) -> void:
	if _entities.has(entity_id):
		_entities[entity_id].erase(effect)
		EventBus.emit_signal("status_effect_removed", entity_id, effect.id)
