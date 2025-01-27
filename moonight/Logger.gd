extends Node

# Logging levels
enum LogLevel { DEBUG, INFO, WARN, ERROR }
@export var log_level: LogLevel = LogLevel.INFO

# Log file path
var log_file_path = "user://game_logs.txt"

# Initialize log file
func _ready():
	var file = FileAccess.open(log_file_path, FileAccess.ModeFlags.WRITE)
	file.close()

# Log a message
func log(message: String, level: LogLevel = LogLevel.INFO):
	if level >= log_level:
		var level_text = ["DEBUG", "INFO", "WARN", "ERROR"][level]
		var log_message = "[%s] %s: %s" % [Time.get_datetime_string_from_system(), level_text, message]
		print(log_message)

		# Write to log file
		var file = FileAccess.open(log_file_path, FileAccess.ModeFlags.WRITE_READ)
		file.seek_end()
		file.store_line(log_message)
		file.close()
