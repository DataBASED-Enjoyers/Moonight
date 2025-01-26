extends CharacterBody2D

@export var speed:= 200.0

var max_health: int = 100
var current_health: int = max_health
var last_move_direction: Vector2 = Vector2.RIGHT  # Default facing right
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var health_label: Label = $HealthLabel
var is_attacking = false
var attack_cooldown_time = 2.0  # Time between attacks
var attack_damage = 10
var attack_timer = 0.5

func _ready():
	$CanvasLayer/ProgressBar.max_value = max_health
	$Area2D.body_entered.connect(_on_attack_hit)

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
		
		if not is_attacking:
			play_animation("Walk", last_move_direction)
	else:
		velocity = Vector2.ZERO
		
		if not is_attacking:
			play_animation("Idle", last_move_direction)

	move_and_slide()

	# Handle Attack Cooldown
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			attack_area.monitoring = false  # Disable attack area
	else:
		if Input.is_action_just_pressed("attack"):
			attack()
			
func attack():
	if is_attacking:
		return
	is_attacking = true
	attack_timer = attack_cooldown_time
	# Enable the attack area
	attack_area.monitoring = true

	# Rotate the attack area to face the last move direction
	var angle = last_move_direction.angle()
	attack_area.rotation = angle
	
	play_animation("Attack_Thrust", last_move_direction)

	
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

func _on_attack_hit(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)
		
func take_damage(amount: int):
	current_health = clamp(current_health - amount, 0, max_health)
	if current_health <= 0:
		current_health = 0
		play_animation("Death", last_move_direction)
	update_health_display()
	# Optional: Add visual feedback or check for death

func update_health_display():
	health_label.text = str(current_health)

func die():
	queue_free()
	play_animation("Death", last_move_direction)
	print("Player defeated!")
