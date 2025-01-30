# tests/health_processor_test.gd
extends "res://addons/gut/test.gd"

var health_processor: HealthProcessor

func before_each():
	health_processor = HealthProcessor.new()
	add_child_autofree(health_processor)

func test_entity_registration():
	health_processor.register_entity("player", 100)
	assert_true(health_processor.is_entity_registered("player"))

func test_damage_application():
	health_processor.register_entity("enemy", 50)
	health_processor.apply_damage(20, "enemy")
	assert_eq(health_processor.get_health("enemy"), 30)
