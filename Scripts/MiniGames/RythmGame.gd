extends Node2D

#W=0, A=1, S=2, D=3

@onready var progressIndicator = $progressIndicator
@onready var audioPlayer = $AudioStreamPlayer
@onready var errorAnim = $AnimationPlayer
@onready var SpritePosition = $LetterPosition
@onready var WSprite = $LetterPosition/WSprite
@onready var ASprite = $LetterPosition/ASprite
@onready var SSprite = $LetterPosition/SSprite
@onready var DSprite = $LetterPosition/DSprite
@onready var tickSprite = $LetterPosition/Tick

var progress = 0

signal repaired

var buttonDict = { 0: "move_up", 1: "move_left", 2: "fall", 3: "move_right"}
var buttons
var next = null
var filled = false

func _ready():
	randomize()
	fillButtons()
	changeKey()
	pass

func fillButtons():
	var counter = 0
	buttons = [null,null,null,null,null,null]
	for x in buttons:
		x = randi() % 4
		buttons[counter] = x
		counter += 1
	next = buttons.pop_back()
	get_tree().create_timer(0.1).timeout
	filled = true

func changeKey():
	WSprite.hide()
	ASprite.hide()
	SSprite.hide()
	DSprite.hide()
	await get_tree().create_timer(0.2).timeout
	match next:
		0:
			WSprite.show()
		1:
			ASprite.show()
		2:
			SSprite.show()
		3:
			DSprite.show()

func showTick():
	WSprite.hide()
	ASprite.hide()
	SSprite.hide()
	DSprite.hide()
	tickSprite.show()
	pass

func updateProgress(correct):
	if correct:
		progress += 1
		get_tree().create_timer(0.1).timeout
		for x in range(progress):
			var indicator = progressIndicator.get_node("Indicator" + str(x+1) + "/solved")
			indicator.show()
			pass
		pass
	else:
		var indicator = progressIndicator.get_node("Indicator" + str(progress+1) + "/error")
		progress = 0
		indicator.show()
		await get_tree().create_timer(0.2).timeout
		indicator.hide()
		for x in range(5):
			indicator = progressIndicator.get_node("Indicator" + str(x+1) + "/solved")
			indicator.hide()
			pass
		pass
	pass

func _process(_delta):
	if(!next==null):
		if Input.is_action_just_pressed(buttonDict[next]):
			next = buttons.pop_back()
			updateProgress(true)
			if(!next==null):
				changeKey()
			else:
				emit_signal("repaired")
		elif(Input.is_action_just_pressed(buttonDict[0])
		||Input.is_action_just_pressed(buttonDict[1])
		||Input.is_action_just_pressed(buttonDict[2])
		||Input.is_action_just_pressed(buttonDict[3])):
			audioPlayer.play(0.0)
			fillButtons()
			changeKey()
			errorAnim.play("Error")
			updateProgress(false)
	elif(filled):
		showTick()
	pass
