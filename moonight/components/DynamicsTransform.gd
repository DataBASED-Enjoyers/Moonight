class_name DynamicsTransform
extends Node2D

@export var f: float = 1.0
@export var zeta: float = 0.5
@export var r: float = 0.0
@export var track_position := true

var _system_x := SecondOrderDynamics.new()
var _system_y := SecondOrderDynamics.new()

func _ready():
	var pos = global_position
	_system_x.initialize(f, zeta, r, pos.x)
	_system_y.initialize(f, zeta, r, pos.y)

func _process(delta: float):
	if track_position:
		var target = get_parent().global_position
		global_position = Vector2(
			_system_x.update(target.x, 0.0, delta),
			_system_y.update(target.y, 0.0, delta)
		)
