extends Node2D

signal gameOverSignal(score: float)

@onready var pauseMenuNode = $PauseMenu
@onready var gameOverScreen = $GameOverScreen
@onready var spawnTimer = $Timer
@onready var speedUpTimer = $speedUpTimer
@onready var score_ui = $ParallaxBackground/Score/MarginContainer/Score

@export var GearGame: PackedScene
@export var RythmGame: PackedScene
@export var OilPipes: PackedScene


@export var damaged_scene: PackedScene

@onready var h_pointer = $ParallaxBackground/Clock/h_center
@onready var min_pointer = $ParallaxBackground/Clock/min_center
@onready var sec_pointer = $ParallaxBackground/Clock/sec_center
@onready var rope = $BoostRope/AnimationPlayer
@onready var bell = $BoostRope/DingDong

@onready var confirmAudio = $confirm

#the number of currently damaged Parts
var brokenParts = 0
#if more than this number of parts are damaged the game is over
var maxBrokenParts = 4
#a 2D Array that shows if one of the parts is broken, and has a reference to the instance of the broken part scene
var parts = [[false,null], [false,null], [false,null], [false,null], [false,null]]

var score = 0

var boost_available = false

var boost = 1

#checks if the game is paused
var paused = false

var isGameOverScreenShowing = false

#counts up to twelve, so that the hour pointer only rotates once every 12th time processing is called
var hourCounter = 0

#the index of the platform the player is above
var currentArea = 0

#the time in seconds between spawns of damaged parts
var spawnPeriod = 10

#false if the areas have been set to 0 at the start
var fixArea = true 															# TODO check if necessery, because its bugged

signal repaired
signal repairStarted

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

#creates a damaged part
func spawnDamage(index):
	if(!parts[index-1][0]):
		var part = damaged_scene.instantiate()
		brokenParts += 1
		parts[index-1][0] = true
		var platformPath = "Platform" + str(index)
		var platform = get_node(platformPath)
		part.position = platform.position
		part.position.y -= 50
		parts[index-1][1] = part
		add_child(part)
		part.z_index = -1
		return(true)
	else:
		return(false)

#starts repairing a damaged part, if the player character is currently in its zone
func startRepairDamage(repairArea):
	if(repairArea>0 && parts[repairArea-1][0]):
		#TODO add move to minigame
		emit_signal("repairStarted")
		var choice = randi()%3
		var minigame = null
		match choice:
			0:
				minigame = GearGame.instantiate()
			1:
				minigame = OilPipes.instantiate()
			2:
				minigame = RythmGame.instantiate()
		add_child(minigame)
		await minigame.repaired
		confirmAudio.play(0.0)
		await get_tree().create_timer(0.5).timeout
		minigame.queue_free()
		brokenParts -= 1
		parts[repairArea-1][1].queue_free()
		parts[repairArea-1][0] = false
		emit_signal("repaired")
		return true
	pass

#switches to the Game Over scene
func gameOver():
	gameOverScreen.show()
	gameOverSignal.emit(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isGameOverScreenShowing:
		return
	
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
	if(brokenParts == maxBrokenParts + 1):
		gameOver()
		isGameOverScreenShowing = true
		
	
	if(hourCounter == 12):
		h_pointer.rotation_degrees -= 1 * delta / (brokenParts + 1) * boost
		hourCounter = 0
	min_pointer.rotation_degrees -= 1 * delta / (brokenParts + 1) * boost
	sec_pointer.rotation_degrees -= 60 * delta / (brokenParts + 1) * boost
	hourCounter += 1
	
	score += 10 * delta / (brokenParts + 1) * boost
	score_ui.text = "Score: " + str(int(score))

func pauseMenu():
	if paused:
		pauseMenuNode.hide()
		Engine.time_scale = 1
	else:
		pauseMenuNode.show()
		Engine.time_scale = 0	
	paused = !paused

func _on_platform_1_repair_area_entered(body):
	if body.name == "Bolt":
		print(1)
		currentArea = 1

func _on_platform_1_repair_area_exited(body):
	if body.name == "Bolt":
		currentArea = 0
		print(1)

func _on_platform_2_repair_area_entered(body):
	if body.name == "Bolt":
		currentArea = 2
		print(2)

func _on_platform_2_repair_area_exited(body):
	if body.name == "Bolt":
		currentArea = 0
		print(2)

func _on_platform_3_repair_area_entered(body):
	if body.name == "Bolt":
		currentArea = 3
		print(3)

func _on_platform_3_repair_area_exited(body):
	if body.name == "Bolt":
		print(3)
		currentArea = 0

func _on_platform_4_repair_area_entered(body):
	if body.name == "Bolt":
		currentArea = 4
		print(4)

func _on_platform_4_repair_area_exited(body):
	if body.name == "Bolt":
		currentArea = 0
		print(4)

func _on_platform_5_repair_area_entered(body):
	if body.name == "Bolt":
		currentArea = 5
		print(5)

func _on_platform_5_repair_area_exited(body):
	if body.name == "Bolt":
		currentArea = 0
		print(5)

func _on_bolt_interact():
	print(currentArea)
	if boost_available:
		rope.play("pull")
		delay_bell(0.2)
		boost = 10
		await get_tree().create_timer(3).timeout			
		boost = 1
	else:
		startRepairDamage(currentArea)

func delay_bell(sec):
	await get_tree().create_timer(sec).timeout	
	bell.play(0)		

func _on_timer_timeout():
	var randomPlatform = (randi()%5)+1
	while(!spawnDamage(randomPlatform)):
		randomPlatform = (randi()%5)+1
		pass
	spawnTimer.start(spawnPeriod+(randi()%5))
	
	if(fixArea):																
	#	currentArea = 0															# TODO check if necessery, because its bugged
		boost_available = false

func _on_audio_stream_player_finished():
	var songPlayer = $AudioStreamPlayer
	songPlayer.play()	
	pass # Replace with function body.

func _on_boost_body_entered(body):
	boost_available = true

func _on_boost_body_exited(body):
	boost_available = false


func _on_speed_up_timer_timeout():
	if(spawnPeriod>5):
		spawnPeriod -= 1
	pass # Replace with function body.
