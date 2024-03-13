extends Control

@onready var credits = $MarginContainer/VBoxContainer2/ReferenceRect/Credits
@onready var animationplayerCredits = $MarginContainer/VBoxContainer2/ReferenceRect/Credits/AnimationPlayer
@onready var creditScene = $CreditsScene
@onready var controlSzene = $Control

var spin = false
var creditButtonHover = false
var creditSceneShowing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spin:
		animationplayerCredits.play("rotation")
	else:
		animationplayerCredits.pause()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Intro/Intro.tscn")


func _on_exit_pressed():
	get_tree().quit();


func _input(event):
	if creditButtonHover == true:
		if Input.is_action_pressed("left_klick"):
			creditScene.show()


func _on_reference_rect_mouse_entered():
	spin = true
	creditButtonHover = true
	credits.scale = Vector2(2.3, 2.3)
	


func _on_reference_rect_mouse_exited():
	spin = false
	creditButtonHover = false
	credits.scale = Vector2(2, 2)


func _on_controls_pressed():
	controlSzene.show()
	
	pass
