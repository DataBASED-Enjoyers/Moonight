# ui/scene_transition.gd
class_name SceneTransition extends ColorRect

@export var transition_time: float = 0.5
@export var transition_curve: Curve

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	material = material.duplicate()

func fade_in():
	anim_player.play("fade_in")

func fade_out():
	anim_player.play("fade_out")

# Connect to GameManager events
func _on_scene_changing():
	fade_in()
	await anim_player.animation_finished

func _on_scene_changed():
	fade_out()
