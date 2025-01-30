extends Entity

@onready var player_ow_speed = speed
@onready var player_ow_max_health = max_health
@onready var player_ow_entity_types = entity_types
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_processor = get_node("/root/HealthProcessor")
@onready var status_processor = get_node("/root/StatusProcessor")
var last_move_direction: Vector2 = Vector2.RIGHT  # Default facing right
var player_ow_health = max_health

func _ready():
	print("Overworld Player ready!")
	health_processor.register_entity(name, player_ow_max_health)
	status_processor.register_entity(name, player_ow_entity_types)
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
		play_animation("Walk", last_move_direction)
	else:
		velocity = Vector2.ZERO		
		play_animation("Idle", last_move_direction)

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
	
func take_damage(amount: int):
	player_ow_health = HealthProcessor \
		.process_health_change(name, amount, true)
	
func heal(amount: int):
	player_ow_health = HealthProcessor \
		.process_health_change(name, amount, false)

func die():
	play_animation("Death", last_move_direction)
	print("%s has died!" % name)
	print("Player OW defeated!")
	HealthProcessor.deregister_entity(name)
	StatusProcessor.deregister_entity(name)
	#queue_free()
