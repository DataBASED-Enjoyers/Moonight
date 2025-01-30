# components/HealthComponent.gd
class_name HealthComponent extends Node

signal died
signal health_changed(new_health: int, max_health: int)

@export var max_health: int = 100

var current_health: int:
	set(value):
		current_health = clamp(value, 0, max_health)
		health_changed.emit(current_health, max_health)
		if current_health <= 0:
			died.emit()

func _ready():
	current_health = max_health
	EventBus.entity_registered.emit(get_parent())
	
func _exit_tree():
	EventBus.entity_deregistered.emit(get_parent())

func apply_damage(amount: int):
	current_health -= amount
	EventBus.damage_applied.emit("world", get_parent(), amount)

func apply_healing(amount: int):
	current_health += amount
