extends Node


func _on_Exit_pressed():
    get_tree().quit()


func _on_StartGame_pressed():
    get_tree().change_scene("res://Level.tscn")


func _on_Continue_pressed():
    pass
