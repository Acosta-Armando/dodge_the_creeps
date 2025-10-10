extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message('Game Over')
	await $MessageTimer.timeout
	
	$Message.text = 'Dodge the Creeps!'
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$QuitButton.show()
	$HelpButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$QuitButton.hide()
	$HelpButton.hide()
	$Help.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_help_button_pressed() -> void:
	$Help.show()
