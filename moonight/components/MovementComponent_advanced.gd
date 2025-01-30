# components/MovementComponent_advanced.gd
class_name MovementComponent_advanced extends CharacterBody2D

@export var move_speed: int = 200
@export var acceleration: float = 0.2
@export var body_sway: DynamicsTransform
@export var head_tilt: DynamicsTransform

var input_direction: Vector2 = Vector2.ZERO
var facing_direction: Vector2 = Vector2.RIGHT

func process_movement(delta: float):
	velocity = velocity.lerp(input_direction * move_speed, acceleration)
	move_and_slide()
	
	if input_direction != Vector2.ZERO:
		facing_direction = input_direction.normalized()

func _ready():
	# Configure body sway with anticipation
	body_sway.f = 2.0
	body_sway.zeta = 0.5
	body_sway.r = -1.5  # Negative r for anticipation
	
	# Configure head tilt with slower response
	head_tilt.f = 1.2
	head_tilt.zeta = 1.0
	head_tilt.r = 0.0

func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var target_rot := input_dir.x * 5.0  # Lean into movement
	
	# Apply dynamics to body rotation
	body_sway.rotation = deg_to_rad(target_rot)
	
	# Secondary head motion
	head_tilt.rotation = deg_to_rad(target_rot * 0.3)
	
	#super._physics_process(delta)
