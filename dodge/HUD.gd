extends CanvasLayer

signal start_game
signal wind_starts
signal noclip

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_wind_timer_timeout():
	wind_starts.emit()
	
func update_wind(wind):
	$WindLabel.text = str(wind) + " wind!" 
	$WindLabel.show()


func _on_no_clip_toggled(button_pressed):
	noclip.emit()
