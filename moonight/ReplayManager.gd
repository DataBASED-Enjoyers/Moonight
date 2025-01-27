extends Node
class_name ReplayManager

# Replay data structure
var replay_data = []
var is_recording = false
var is_playing_back = false
var playback_index = 0

# Start recording a replay
func start_recording():
	replay_data.clear()
	is_recording = true
	is_playing_back = false
	Logger.log("Replay recording started.", Logger.LogLevel.INFO)

# Stop recording
func stop_recording():
	is_recording = false
	Logger.log("Replay recording stopped.", Logger.LogLevel.INFO)

# Save replay to file
func save_replay(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
	file.store_var(replay_data)
	file.close()
	Logger.log("Replay saved to %s" % file_path, Logger.LogLevel.INFO)

# Load replay from file
func load_replay(file_path: String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
		replay_data = file.get_var()
		file.close()
		Logger.log("Replay loaded from %s" % file_path, Logger.LogLevel.INFO)
		return true
	else:
		Logger.log("Replay file %s not found." % file_path, Logger.LogLevel.WARN)
		return false

# Start playback
func start_playback():
	if replay_data.empty():
		Logger.log("No replay data to play back.", Logger.LogLevel.WARN)
		return
	is_playing_back = true
	playback_index = 0
	Logger.log("Replay playback started.", Logger.LogLevel.INFO)

# Process playback
func process_playback(delta: float):
	if is_playing_back and playback_index < replay_data.size():
		var event = replay_data[playback_index]
		handle_replay_event(event)
		playback_index += 1
	elif playback_index >= replay_data.size():
		is_playing_back = false
		Logger.log("Replay playback finished.", Logger.LogLevel.INFO)

# Handle a replay event (override in child classes)
func handle_replay_event(event):
	Logger.log("Handling replay event: %s" % str(event), Logger.LogLevel.DEBUG)
