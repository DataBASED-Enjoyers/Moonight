extends CharacterBody2D
class_name Entity

@export var max_health: int = 100
@export var speed: int = 200
@export var entity_types: Array = ["Generic"]
var entity_health = max_health

func _ready():
	HealthProcessor.register_entity(get_path(), max_health)
	StatusProcessor.register_entity(get_path())

func take_damage(amount: int):
	entity_health = HealthProcessor \
		.process_health_change(get_path(), amount, false)
	if entity_health <= 0:
		die()

func heal(amount: int):
	entity_health = HealthProcessor \
		.process_health_change(get_path(), amount, false)

func die():
	print("%s has died!" % name)
	HealthProcessor.deregister_entity(get_path())
	StatusProcessor.deregister_entity(get_path())
	#queue_free()
