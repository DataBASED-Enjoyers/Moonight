extends CanvasLayer

@onready var start_button = $VBoxContainer/StartGameButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	print_tree()
	start_button.pressed.connect(_on_start_run_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_run_pressed():
	GameManager.start_run()

func _on_quit_pressed():
	GameManager.quit_game()
