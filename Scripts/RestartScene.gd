extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_RestartButton_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")
	pass


func _on_ExitButton_pressed():
	get_tree().quit()
	pass
