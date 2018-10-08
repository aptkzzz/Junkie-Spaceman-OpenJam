extends CanvasLayer

func _ready():
    set_visibilities(true)

func set_hp(value):
    $HPBar.value = value

func set_score(value):
    $ScoreText.text = str(value)

func set_visibilities(ingame=false):
    $HPBar.visible = ingame
    $ScoreText.visible = ingame
    $MessageLabel.visible = not ingame
    $RestartButton.visible = not ingame
    $ToMenu.visible = not ingame
	
	
func set_message(value):
    $MessageLabel.text = value

func player_death():
    set_message("Game Over")
    set_visibilities()

func success_end():
    set_message("Congratulations!")
    set_visibilities()

func _on_ToMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
