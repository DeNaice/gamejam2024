extends Control

@onready var main = $".."
@onready var gameScore = $"../ParallaxBackground/Score"
@onready var explosion1 = $Explosions/SmallExplosion1
@onready var explosion2 = $Explosions/SmallExplosion2
@onready var explosion3 = $Explosions/SmallExplosion3
@onready var explosion4 = $Explosions/BigExplosion
@onready var highscore = $MarginContainer/VBoxContainer/Highscore
@onready var scoreLabel = $MarginContainer/VBoxContainer/Score
@onready var text = $MarginContainer
@onready var blur = $ColorRect

var save_data: SaveData

func _ready():
	save_data = SaveData.load_or_create()
	main.gameOverSignal.connect(explode)


func explode(score: float):
	explosion1.play("multiple_explosion")
	await get_tree().create_timer(0.3).timeout
	explosion3.play("multiple_explosion")
	await get_tree().create_timer(0.3).timeout
	explosion2.play("multiple_explosion")
	await get_tree().create_timer(0.5).timeout
	explosion4.play("single_explosion")
	await get_tree().create_timer(0.3).timeout
	gameScore.hide()
	text.show()
	blur.show()
	if score > save_data.high_score:
		save_data.high_score = score
		save_data.save()
	highscore.text = "Your Highscore: " + str(int(save_data.high_score))
	scoreLabel.text = "Your Score: " + str(int(score))
	await get_tree().create_timer(3).timeout
	Engine.time_scale = 0


func _on_restart_pressed():
	Engine.time_scale = 1
	main.get_tree().reload_current_scene()


func _on_main_menu_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/Navigation/Menu.tscn")
