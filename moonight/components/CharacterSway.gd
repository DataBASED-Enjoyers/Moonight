# components/CharacterSway.gd
# absolutely no idea what goes on here
extends Node2D

@export var body_sway: DynamicsTransform
@export var head_sway: DynamicsTransform
@export var max_sway_offset: Vector2 = Vector2(10, 5)

func _ready():
	# Body: Slow, bouncy movement
	body_sway.f = 1.2
	body_sway.zeta = 0.4
	body_sway.r = -0.5  # Anticipate motion

	# Head: Delayed follow
	head_sway.f = 0.8
	head_sway.zeta = 0.7
	head_sway.r = 0.3
