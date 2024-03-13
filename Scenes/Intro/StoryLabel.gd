extends Label

@onready var timer = $Timer
var fullText := "
In a world where time ticks as unpredictably as a faulty alarm clock, there exists a small robot named Bolt. Today marks a special day for him – his first day within the grand clock tower, the heartbeat of the city. Bursting with enthusiasm, Bolt is ready to mend time and keep the world in rhythm. However, it soon becomes apparent that the clock tower has a glitch, posing a challenge even for a talented robot like Bolt. Join Bolt as he strives to keep time in check!"
var currentText := ""
var currentIndex := 0
var displaySpeed := 0.02 # Ändere die Geschwindigkeit nach Bedarf

func _ready():
	timer.start(displaySpeed)
	

func update_text():
	text = currentText
	if currentIndex < fullText.length():
		currentText += fullText[currentIndex]
		currentIndex += 1
		timer.start(displaySpeed)
		
func _on_timer_timeout():
	timer.stop()
	update_text()
