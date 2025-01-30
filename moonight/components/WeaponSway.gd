# components/WeaponSway.gd
# absolutely no idea what goes on here
extends Node2D

@export var sway_system: DynamicsTransform
@export var max_sway_offset: Vector2 = Vector2(10, 5)

func _ready():
	sway_system.f = 3.0
	sway_system.zeta = 0.7
	sway_system.r = 1.2

func _process(delta: float):
	var mouse_delta := Input.get_last_mouse_velocity()
	var target_offset := Vector2(
		mouse_delta.x * max_sway_offset.x,
		mouse_delta.y * max_sway_offset.y
	)
	
	position = sway_system.update(target_offset, delta)
