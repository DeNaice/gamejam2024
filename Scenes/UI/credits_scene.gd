extends Control

@onready var closeButton = $Button
@onready var creditScene = $"."


func _on_button_pressed():
	creditScene.hide()
