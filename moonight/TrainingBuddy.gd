extends CharacterBody2D  # Or Node2D if applicable

var last_move_direction: Vector2 = Vector2.LEFT  # Default facing right
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	$CanvasLayer/ProgressBar.max_value = GameManager.buddy_max_health
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
	GameManager.update_health("buddy", -amount)
	if GameManager.buddy_health  <= 0:
		die()
	# Optional: Add visual feedback or check for death
	
func die():
	play_animation("Death", last_move_direction)
	#queue_free()
	print("Training Buddy defeated!")
