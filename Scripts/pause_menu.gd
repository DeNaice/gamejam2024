extends Control

@onready var main = $".."


func _on_resume_pressed():
	main.pauseMenu()


func _on_main_menu_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/Navigation/Menu.tscn")


func _on_reset_pressed():
	Engine.time_scale = 1
	main.get_tree().reload_current_scene()
