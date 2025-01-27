extends CharacterBody2D

@export var speed:= 200.0

var last_move_direction: Vector2 = Vector2.RIGHT  # Default facing right
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#func _ready():
	#$CanvasLayer/ProgressBar.max_value = GameManager.player_max_health
	#$Area2D.body_entered.connect(_on_attack_hit)

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		last_move_direction = input_vector  # Update last move direction
		velocity = input_vector * speed
	move_and_slide()

func play_animation(base_animation_name: String, direction: Vector2):
	var dir = direction.normalized()
	var animation_name = base_animation_name

	# Determine facing direction
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animation_name += "_Right"
			animated_sprite.flip_h = false
		else:
			animation_name += "_Left"
			animated_sprite.flip_h = false
	else:
		if dir.y > 0:
			animation_name += "_Front"
		else:
			animation_name += "_Back"
			
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func die():
	#queue_free()
	play_animation("Death", last_move_direction)
	print("Player defeated!")
