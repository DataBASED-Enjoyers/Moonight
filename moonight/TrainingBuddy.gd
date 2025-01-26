extends CharacterBody2D  # Or Node2D if applicable

var max_health: int = 100
var last_move_direction: Vector2 = Vector2.LEFT  # Default facing right
var current_health: int = max_health
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_label: Label = $HealthLabel

func _ready():
	update_health_display()
	animated_sprite.play("Idle_Front") 
	
func take_damage(amount: int):
	current_health = clamp(current_health - amount, 0, max_health)
	if current_health <= 0:
		current_health = 0
		play_animation("Death", last_move_direction)
	update_health_display()
	# Optional: Add visual feedback or check for death

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

func update_health_display():
	health_label.text = str(current_health)
	
func die():
	queue_free()
	play_animation("Death", last_move_direction)
	print("TrainingBuddy defeated!")
