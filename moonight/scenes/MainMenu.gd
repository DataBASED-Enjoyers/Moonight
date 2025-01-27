extends CanvasLayer

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_game_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_game_pressed():
	GameRoot.start_game()

func _on_quit_pressed():
	get_tree().quit()
