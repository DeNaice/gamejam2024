extends Node2D
@onready var animationplayer = $AnimationPlayer
@onready var story = $AnimationPlayer/Story
@onready var skip = $AnimationPlayer/Skip
@onready var weiter = $AnimationPlayer/Weiter
@onready var player = $AnimationPlayer/player
@onready var bubbletext = $BubbleLabel
@onready var kitty = $PssstLassmichschlafen
@onready var bubble = $Speechbubble
# Called when the node enters the scene tree for the first time.

var screen1 = true

func _ready():
	# Zuerst verstecken wir alles solange die Story durchläuft
	kitty.hide()
	story.show()
	player.hide()
	bubbletext.hide()
	weiter.hide()
	bubble.hide()
	
	#25 Sekunden passen ziemlich gut aber erstmal 0 zum programmieren 
	await get_tree().create_timer(0).timeout
	weiter.show()

func _on_weiter_pressed():
	if(screen1):
		#await get_tree().create_timer(0.1).timeout
		animationplayer.play("Intro")
		bubbletext.update_text()
		screen1=false
	else:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	pass # Replace with function body.


func _on_skip_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
