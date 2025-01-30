# components/AnimationComponent.gd
class_name AnimationComponent extends Node

enum State { IDLE, WALK, ATTACK, HURT, DEAD }
@export var current_state: State = State.IDLE
@export var animated_sprite: AnimatedSprite2D

var _previous_state: State
var _blend_space: Vector2

func update_state(direction: Vector2, is_moving: bool, is_attacking: bool):
	_blend_space = direction.normalized()
	
	if is_attacking:
		_transition_to(State.ATTACK)
	elif is_moving:
		_transition_to(State.WALK)
	else:
		_transition_to(State.IDLE)

func _transition_to(new_state: State):
	if current_state == new_state: return
	_previous_state = current_state
	current_state = new_state
	_update_animation()

func _update_animation():
	var animation_name = State.keys()[current_state].to_lower()
	var direction = _get_direction_suffix()
	animated_sprite.play("%s_%s" % [animation_name, direction])

func _get_direction_suffix() -> String:
	if abs(_blend_space.x) > abs(_blend_space.y):
		return "side" if _blend_space.x > 0 else "side"
	else:
		return "back" if _blend_space.y < 0 else "front"
