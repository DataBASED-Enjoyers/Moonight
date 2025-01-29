extends Node

enum LogLevel { DEBUG, INFO, WARN, ERROR }
const MAX_LOG_FILES = 5

@export var file_log_level: LogLevel = LogLevel.DEBUG
@export var console_log_level: LogLevel = LogLevel.INFO

var _log_file: FileAccess
var _log_buffer := []

func _ready() -> void:
	_rotate_logs()
	_open_log_file()
	_print_system_info()

func _exit_tree() -> void:
	_flush_buffer()
	if _log_file:
		_log_file.close()

func game_log(message: String, level: LogLevel = LogLevel.INFO) -> void:
	var timestamp = Time.get_datetime_string_from_system()
	var log_entry = "[%s][%s] %s" % [timestamp, _level_to_string(level), message]
	
	# Console output
	if level >= console_log_level:
		print(log_entry)
	
	# File output
	if level >= file_log_level:
		_log_buffer.append(log_entry)
		if _log_buffer.size() >= 10:
			_flush_buffer()

func _flush_buffer() -> void:
	if _log_file and _log_buffer.size() > 0:
		_log_file.store_string("\n".join(_log_buffer) + "\n")
		_log_buffer.clear()

func _rotate_logs() -> void:
	var dir = DirAccess.open("user://")
	if dir:
		var logs = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with("log_") and file_name.ends_with(".txt"):
				logs.append(file_name)
			file_name = dir.get_next()
		
		logs.sort()
		while logs.size() >= MAX_LOG_FILES:
			var old_log = logs.pop_front()
			dir.remove("user://" + old_log)

func _open_log_file() -> void:
	var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
	var file_path = "user://log_%s.txt" % timestamp
	_log_file = FileAccess.open(file_path, FileAccess.WRITE)
	if not _log_file:
		push_error("Failed to open log file: %s" % file_path)

func _print_system_info() -> void:
	game_log("=== System Information ===")
	game_log("OS: %s" % OS.get_name())
	game_log("Engine Version: %s" % Engine.get_version_info())
	game_log("Rendering Device: %s" % (DisplayServer.get_name()))
	game_log("==========================")

func _level_to_string(level: LogLevel) -> String:
	return ["DEBUG", "INFO", "WARN", "ERROR"][level]
