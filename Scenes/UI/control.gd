extends Control

@onready var closeButton = $Button
@onready var controlSzene = $"."

func _on_button_pressed():
	controlSzene.hide()
