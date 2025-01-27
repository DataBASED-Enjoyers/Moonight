extends CanvasLayer

func update_health(player_health, player_max_health, buddy_health, buddy_max_health):
	$UI_Control/PlayerHealthBar.max_value = player_max_health
	$UI_Control/PlayerHealthBar.value = player_health

	$UI_Control/BuddyHealthBar.max_value = buddy_max_health
	$UI_Control/BuddyHealthBar.value = buddy_health
