# autoloads/player_data_manager.gd
extends Node

## Autoload name: PlayerDataManager (set via Project Settings)
signal currency_changed(new_amount: int)
signal health_changed(new_health: int)

var current_run: PlayerRunData = null

static func get_instance() -> Node:
	return Engine.get_main_loop().root.get_node("/root/PlayerDataManager")

func new_run() -> void:
	current_run = PlayerRunData.new()
	current_run.rng_seed = randi()
	current_run.health = 100
	current_run.max_health = 100

func serialize() -> Dictionary:
	return {
		"health": current_run.health,
		"max_health": current_run.max_health,
		"currency": current_run.currency,
		"upgrades": current_run.upgrades.duplicate(),
		"seed": current_run.rng_seed
	}

func deserialize(data: Dictionary) -> void:
	current_run = PlayerRunData.new()
	current_run.health = data.get("health", 100)
	current_run.max_health = data.get("max_health", 100)
	current_run.currency = data.get("currency", 0)
	current_run.upgrades = data.get("upgrades", [])
	current_run.rng_seed = data.get("seed", 0)

class PlayerRunData extends RefCounted:
	var health: int = 100
	var max_health: int = 100
	var currency: int = 0
	var upgrades: Array[String] = []
	var rng_seed: int = 0
	var current_room: Vector2i = Vector2i.ZERO
