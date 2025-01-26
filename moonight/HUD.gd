extends CanvasLayer

func update_health(player_health, player_max_health, buddy_health, buddy_max_health):
	$Control/PlayerHealthBar.max_value = player_max_health
	$Control/PlayerHealthBar.value = player_health

	$Control/BuddyHealthBar.max_value = buddy_max_health
	$Control/BuddyHealthBar.value = buddy_health
