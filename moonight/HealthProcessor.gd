extends Node

# Signal definition
signal health_changed(entity_id: String, new_health: int, new_max_health: int)
signal death(entity_id: String)

# Centralized health registry
var entity_health = {}

# Add an entity to the registry
func register_entity(
	entity_id: String, 
	max_health: int, 
	current_health: int = max_health
	):
	if entity_id in entity_health:
		print("Entity %s is already registered!" % entity_id)
		return
	entity_health[entity_id] = {"current": current_health, "max": max_health}
	print("Registered entity %s with max health %d and current health %d" % \
		[entity_id, max_health, current_health])

# Remove an entity from the registry
func deregister_entity(entity_id: String):
	if entity_id in entity_health:
		entity_health.erase(entity_id)
		print("Deregistered entity %s" % entity_id)
	else:
		print("Entity %s not found in HealthProcessor!" % entity_id)

# Process health changes
func process_health_change(
	entity_id: String, 
	base_amount: float, 
	is_damage: bool = true
	):
	if entity_id not in entity_health:
		print("Entity %s not registered in HealthProcessor!" % entity_id)
		return

	var health_data = entity_health[entity_id]
	var effect_type = "damage" if is_damage else "heal"

	# Apply status effects
	var final_amount = StatusProcessor.apply_status_effects(
		entity_id, 
		base_amount, 
		effect_type
	)

	# Apply the change
	health_data["current"] += -final_amount if is_damage \
							else final_amount
	health_data["current"] = clamp(
		health_data["current"], 
		-health_data["max"], 
		health_data["max"]
	)
	
	emit_signal(
		"health_changed", 
		entity_id, 
		health_data["current"],
		health_data["max"]
	)

	print("Entity %s health updated: %d/%d" % [
		entity_id, 
		health_data["current"], 
		health_data["max"]
		]
	)
	
		
	return health_data["current"]

# Handle entity death
func on_entity_death(entity_id: String):
	print("Entity %s has died!" % entity_id)
	deregister_entity(entity_id)
	var entity = get_tree().get_node(entity_id)
	if entity and entity.has_method("die"):
		emit_signal("death", entity_id)
		entity.die()
