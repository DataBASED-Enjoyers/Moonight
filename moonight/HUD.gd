extends CanvasLayer

# Reference to HealthProcessor and StatusProcessor
@onready var health_processor = get_node("/root/HealthProcessor")
@onready var status_processor = get_node("/root/StatusProcessor")

func _ready():
	# Connect to signals from HealthProcessor and StatusProcessor to update HUD dynamically
	health_processor.health_changed.connect(_on_HealthProcessor_health_changed)
	status_processor.status_changed.connect(_on_StatusProcessor_status_changed)

	# Initial update
	update_health_display()
	update_status_display()
	
func update_health_display():
	# Assuming there's a Label node named 'HealthLabel' in the HUD
	$UI_Control/PlayerHealthBar.max_value = \
		health_processor.entity_health['Player']['max']
	$UI_Control/PlayerHealthBar.value = \
		health_processor.entity_health['Player']['current']
	
func update_status_display():
	# Assuming there's a Label node named 'StatusLabel' in the HUD
	#$StatusLabel.text = "Status: " + status_processor.current_status
	pass

func _on_HealthProcessor_health_changed():
	update_health_display()

func _on_StatusProcessor_status_changed():
	update_status_display()

#func update_health(player_health, player_max_health, buddy_health, buddy_max_health):
	#$UI_Control/PlayerHealthBar.max_value = player_max_health
	#$UI_Control/PlayerHealthBar.value = player_health
#
	#$UI_Control/BuddyHealthBar.max_value = buddy_max_health
	#$UI_Control/BuddyHealthBar.value = buddy_health
