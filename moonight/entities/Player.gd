# entities/Player.gd
class_name Player extends Entity

func _ready():
	super._ready()
	EventBus.connect("input_event", _on_input_event)

func _on_input_event(event: InputEvent):
	var move_component = get_component("Movement")
	if move_component:
		move_component.input_direction = Input.get_vector(
			"move_left", 
			"move_right", 
			"move_up", 
			"move_down"
		)
	
	if Input.is_action_just_pressed("attack"):
		var combat_component = get_component("Combat")
		if combat_component:
			combat_component.attack()
