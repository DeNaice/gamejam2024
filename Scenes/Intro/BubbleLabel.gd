extends Label

@onready var bubble = $"../Speechbubble"
@onready var timer2 = $Timer2
var fullText := "My first day as a clock tower mechanic! Time to roll up sleeves – if I had any. Oh, trouble in the gears. No problem, Bolt is here to set things right. Let's peek under the clock face! Don't panic, dear clock tower. Even if we 'tick off' a bit today, I'll get you back on track. Time is relative – and especially flexible today!"
var currentText := ""
var currentIndex := 0
var displaySpeed := 0.02 # Ändere die Geschwindigkeit nach Bedarf

func update_text():
	text = currentText
	if currentIndex < fullText.length():
		currentText += fullText[currentIndex]
		currentIndex += 1
		timer2.start(displaySpeed)

func start_timer():
	update_text()

func _on_timer_2_timeout():
	timer2.stop()
	update_text()
