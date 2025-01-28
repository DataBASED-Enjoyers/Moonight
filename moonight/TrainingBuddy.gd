extends Entity 

@onready var buddy_speed = speed
@onready var buddy_max_health = max_health
@onready var buddy_entity_types = entity_types
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_processor = get_node("/root/HealthProcessor")
@onready var status_processor = get_node("/root/StatusProcessor")
var last_move_direction: Vector2 = Vector2.RIGHT  # Default facing right
var buddy_health = max_health

func _ready():
	print("Training Buddy ready!")
	health_processor.register_entity(name, buddy_max_health)
	status_processor.register_entity(name, buddy_entity_types)
	#$Area2D.body_entered.connect(_on_attack_hit)
	animated_sprite.play("Idle_Front") 

func play_animation(base_animation_name: String, direction: Vector2):
	var dir = direction.normalized()
	var animation_name = base_animation_name

	# Determine facing direction
	if animation_name != "Death":
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				animation_name += "_Right"
				animated_sprite.flip_h = false
			else:
				animation_name += "_Left"
				animated_sprite.flip_h = true
		else:
			if dir.y > 0:
				animation_name += "_Front"
			else:
				animation_name += "_Back"
			
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
	
func take_damage(amount: int):
	buddy_health = HealthProcessor \
		.process_health_change(name, amount, true)
	if buddy_health <= 0:
		die()
	
func heal(amount: int):
	buddy_health = HealthProcessor \
		.process_health_change(name, amount, false)
	
func die():
	play_animation("Death", last_move_direction)
	print("%s has died!" % name)
	print("Training Buddy defeated!")
	HealthProcessor.deregister_entity(get_path())
	StatusProcessor.deregister_entity(get_path())
	#queue_free()
