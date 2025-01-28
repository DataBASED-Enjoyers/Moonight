extends ReplayManager

func log_run_event(event: Dictionary):
	if is_recording:
		replay_data.append(event)
		Logger.log("Run event logged: %s" % str(event), Logger.LogLevel.DEBUG)

func handle_replay_event(event):
	# Example: Handle a scene transition during replay
	if event.type == "scene_transition":
		GameManager.load_scene(event.scene_path)
	elif event.type == "player_action":
		# Example: Trigger specific player action
		Logger.log("Replaying player action: %s" % str(event.action), Logger.LogLevel.DEBUG)
