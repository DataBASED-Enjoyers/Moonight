extends Node

# Centralized status registry
var entity_status = {}

# Status effects index
var status_effects = {
	# Reduces damage by 50%
	"Resistant": {"effect_type": "damage", "type": "mult", "value": 0.5},  
	# Increases damage by 50%
	"Vulnerable": {"effect_type": "damage", "type": "mult", "value": 1.5},  
	 # Increases healing by 20%
	"HealingBoost": {"effect_type": "heal", "type": "mult", "value": 1.2},
	# Adds a flat +10 to damage/healing
	"FlatBonus": {"effect_type": "generic", "type": "add", "value": 10}  
}

# Register an entity with its types
func register_entity(entity_id: String, entity_types: Array):
	if entity_id in entity_status:
		print("Entity %s is already registered!" % entity_id)
		return
	entity_status[entity_id] = {"types": entity_types, "flags": {}}
	print("Registered entity %s with types %s" % [entity_id, entity_types])

# Add a status flag
func add_status(entity_id: String, flag: String, duration: float = -1):
	if entity_id not in entity_status:
		print("Entity %s not registered in StatusProcessor!" % entity_id)
		return
	entity_status[entity_id]["flags"][flag] = duration
	print("Added status %s to entity %s with duration %f" % [flag, entity_id, duration])

# Remove a status flag
func remove_status(entity_id: String, flag: String):
	if entity_id in entity_status and flag in entity_status[entity_id]["flags"]:
		entity_status[entity_id]["flags"].erase(flag)
		print("Removed status %s from entity %s" % [flag, entity_id])

# Apply status effects based on type
func apply_status_effects(entity_id: String, base_value: float, effect_type: String) -> float:
	if entity_id not in entity_status:
		print("Entity %s not registered in StatusProcessor!" % entity_id)
		return base_value

	var additive = 0
	var multiplicative = 1.0

	# Iterate over active flags and process relevant effects
	for flag in entity_status[entity_id]["flags"]:
		if flag in status_effects:
			var effect = status_effects[flag]
			if effect["effect_type"] == effect_type \
			or effect["effect_type"] == "generic":
				if effect["type"] == "add":
					additive += effect["value"]
				elif effect["type"] == "mult":
					multiplicative *= effect["value"]

	# Apply additive effects first, then multiplicative effects
	return (base_value + additive) * multiplicative
