extends Node

# Player and buddy health
var player_health = 100
var player_max_health = 100

var buddy_health = 100
var buddy_max_health = 100

# Reference to the HUD (set dynamically)
var hud

# Function to update health
func update_health(who: String, amount: int):
	match who:
		"player":
			player_health = clamp(player_health - amount, 0, player_max_health)
		"buddy":
			buddy_health = clamp(buddy_health - amount, 0, buddy_max_health)
				
	# Update the HUD
	if hud:
		hud.update_health(player_health, player_max_health, buddy_health, buddy_max_health)
