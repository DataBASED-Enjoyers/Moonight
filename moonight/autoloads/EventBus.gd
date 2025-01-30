# EventBus.gd
extends Node

const REPLICATED_SIGNALS = [
	"entity_damaged", "health_changed", "player_moved"
]

# Entity Signals
signal entity_registered(entity_id: String)
signal entity_deregistered(entity_id: String)
signal health_changed(entity_id: String, current: int, max: int)
signal entity_died(entity_id: String)

# Game Flow Signals
signal scene_changed(scene_name: String)
signal game_saved
signal game_loaded

# Combat Signals
signal damage_applied(source_id: String, target_id: String, amount: float)
signal healing_applied(source_id: String, target_id: String, amount: float)
signal status_effect_added(target_id: String, effect_id: String, duration: float)
signal status_effect_removed(target_id: String, effect_id: String)

# System Signals
signal critical_error(message: String)

static func get_instance() -> Node:
	return Engine.get_main_loop().root.get_node("/root/EventBus")
	
func _ready():
	if multiplayer.has_multiplayer_peer():
		for sig in REPLICATED_SIGNALS:
			connect(sig, Callable(self, "_replicate_signal").bind(sig))

func _replicate_signal(args: Array, signal_name: String):
	if multiplayer.is_server():
		rpc("_remote_emit_signal", signal_name, args)

@rpc("any_peer", "call_local", "reliable")
func _remote_emit_signal(signal_name: String, args: Array):
	emit_signal(signal_name, args)
	
