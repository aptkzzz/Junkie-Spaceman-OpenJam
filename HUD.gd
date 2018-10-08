extends CanvasLayer

func _ready():
    set_visibilities(true, false)

func set_hp(value):
    $HPBar.value = value

func set_score(value):
    $ScoreText.text = str(value)

func set_visibilities(ingame, success):
    $HPBar.visible = ingame
    $ScoreText.visible = ingame
    $MessageLabel.visible = not ingame
    $RestartButton.visible = not ingame and not success
    $ToMenu.visible = not ingame and not success
	
	
func set_message(value):
    $MessageLabel.text = value

func player_death():
    $GameOver.play(0)
    set_message("Game Over")
    set_visibilities(false, false)

func success_end():
    $EpicWin.play(0)
    set_message("Congratulations!")
    set_visibilities(false, true)

func _on_ToMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
