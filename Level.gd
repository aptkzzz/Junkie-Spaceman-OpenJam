extends Node2D

export (String) var next_level_path

func successful_end():
    $LevelTimer.start()

func _on_LevelTimer_timeout():
    get_tree().change_scene(next_level_path)