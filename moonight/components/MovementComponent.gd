# components/MovementComponent.gd
class_name MovementComponent extends CharacterBody2D

@export var move_speed: int = 200
@export var acceleration: float = 0.2

var input_direction: Vector2 = Vector2.ZERO
var facing_direction: Vector2 = Vector2.RIGHT

func process_movement(delta: float):
	velocity = velocity.lerp(input_direction * move_speed, acceleration)
	move_and_slide()
	
	if input_direction != Vector2.ZERO:
		facing_direction = input_direction.normalized()
