# resources/status_effects_db.gd
class_name StatusEffectsDB extends Resource

@export var effects: Array[StatusEffectDefinition] = []

func get_effect(id: String) -> StatusEffectDefinition:
	for effect in effects:
		if effect.id == id:
			return effect
	return null

# Sub-resource for individual effects
class StatusEffectDefinition extends Resource:
	@export var id: String = ""
	@export_multiline var description: String = ""
	@export var icon: Texture2D
	@export var duration: float = 5.0
	@export var modifiers: Array[StatusModifier] = []
	@export var stack_type: int = StackType.STACK_DURATION
	@export var max_stacks: int = 1
	
	enum StackType {
		STACK_DURATION,
		STACK_INTENSITY,
		NO_STACK
	}

class StatusModifier extends Resource:
	@export var target_property: String = "damage"  # damage/heal/movement_speed/etc
	@export var operation: String = "add"           # add/multiply/set
	@export var value: float = 0.0
