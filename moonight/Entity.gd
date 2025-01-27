extends CharacterBody2D

@export var max_health: int = 100
@export var entity_types: Array = ["Generic"]

func _ready():
	HealthProcessor.register_entity(get_path(), max_health)
	StatusProcessor.register_entity(get_path(), entity_types)

func take_damage(amount: int):
	HealthProcessor.process_health_change(get_path(), amount, true)

func heal(amount: int):
	HealthProcessor.process_health_change(get_path(), amount, false)

func die():
	print("%s has died!" % name)
	HealthProcessor.deregister_entity(get_path())
	StatusProcessor.deregister_entity(get_path())
	queue_free()
