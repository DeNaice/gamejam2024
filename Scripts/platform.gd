extends StaticBody2D


signal repairAreaEntered
signal repairAreaExited

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_repair_area_body_entered(body):
	emit_signal("repairAreaEntered", body)
	pass # Replace with function body.

func _on_repair_area_body_exited(body):
	emit_signal("repairAreaExited", body)
	pass # Replace with function body.
