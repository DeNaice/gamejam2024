extends Node2D
@onready var sound1 = $sound1
@onready var sound2 = $sound2
@onready var sound3 = $sound3
@onready var sound4 = $sound4
@onready var gears = $Gears

# running gears 4-10 are hidden on start => get visible if counterpart gets hidden
@onready var gear_01 = $"Gears/01"
@onready var gear_02 = $"Gears/02"
@onready var gear_03 = $"Gears/03"
@onready var gear_04 = $"Gears/04"
@onready var gear_05 = $"Gears/05"
@onready var gear_06 = $"Gears/06"
@onready var gear_07 = $"Gears/07"
@onready var gear_08 = $"Gears/08"
@onready var gear_09 = $"Gears/09"
@onready var gear_10 = $"Gears/10"

# group 1 hidden when m_1 ist set
@onready var gear_dup_04 = $"Gears/04_dup"
@onready var gear_dup_05 = $"Gears/05_dup"

# group 2 hidden when m_1 and m_2 is set
@onready var gear_dup_06 = $"Gears/06_dup"
@onready var gear_dup_07 = $"Gears/07_dup"

# group 3 hidden when all gears are set => win
@onready var gear_dup_08 = $"Gears/08_dup"
@onready var gear_dup_09 = $"Gears/09_dup"
@onready var gear_dup_10 = $"Gears/10_dup"

# group 0 gets visible when set => causes groups to get hidden/visiblepai
@onready var m_gear_01 = $Gears/movable1
@onready var m_gear_02 = $Gears/movable2
@onready var m_gear_03 = $Gears/movable3

# showed if moveable gear is set but not moveing
@onready var m_dup_02 = $Gears/movable2_dup
@onready var m_dup_03 = $Gears/movable3_dup

# areas where movable_gears can be set
@onready var a_1 = $Gears/Anchor1
@onready var a_2 = $Gears/Anchor2
@onready var a_3 = $Gears/Anchor3

# movable_gears => cause hide/visible groups if set
@onready var m_1 = $Medium_Gear/m1
@onready var m_2 = $Small_Gear/m2
@onready var m_3 = $Big_Gear/m3

signal repaired

# enable graups if true in right combination
var m_1_set = false
var m_2_set = false
var m_3_set = false

# enables set / put gear
var anchor_entered = 0
var gear_entered = 0 		# Medium: 1 | Small: 2 | Big: 3
var gear_holding = 0		# Medium: 1 | Small: 2 | Big: 3

# initialized on ready
var m_1_default_pos
var m_2_default_pos
var m_3_default_pos

var variant


func _ready():
	sound1.play(0)
	m_1_default_pos = m_1.position
	m_2_default_pos = m_2.position
	m_3_default_pos = m_3.position
	
	variant = randi() % 4
	match variant: # 0 is default
		1:
			gears.scale = Vector2(-3, 3) 
			gears.position += Vector2(1070, -20)
		2:
			gears.scale = Vector2(3, -3)
			gears.position += Vector2(0, 600)
		3:
			gears.scale = Vector2(-3, -3)
			gears.position += Vector2(1070, 600)



func _process(delta):
	gear_animation(delta)
	
	if Input.is_action_just_pressed("left_klick"):
		if gear_holding:
			match gear_holding:
				1: # medium_gear
					if anchor_entered == 1:
						m_1.position = a_1.position
						m_1_set = true
						refresh_gears()
					else:	
						m_1.position = m_1_default_pos
					gear_holding = 0
				2: # small gear
					if anchor_entered == 2:
						m_2.position = a_2.position
						m_2_set = true
						refresh_gears()
					else:
						m_2.position = m_2_default_pos
					gear_holding = 0
				3: # big gear
					if anchor_entered == 3:
						m_3.position = a_2.position + Vector2(73, -2)
						m_3_set = true
						refresh_gears()
					else:	
						m_3.position = m_3_default_pos
					gear_holding = 0
		elif gear_entered: 										# mouse over gear
			gear_holding = gear_entered
	else: 														# hold gear
		var m_pos = get_viewport().get_mouse_position()
		match gear_holding:
			1: # medium_gear
				m_1.position = m_pos / 3
			2: # small gear
				m_2.position = m_pos / 3
			3: # big gear
				m_3.position = m_pos / 3
				m_3.position.x += 10



func refresh_gears():
	if m_3_set:
		m_3.hide()
		m_dup_03.show()
	if m_2_set:
		m_2.hide()
		m_dup_02.show()
		
	if m_1_set:
		sound2.play(0)
		m_1.hide()
		gear_dup_04.hide()
		gear_dup_05.hide()
		m_gear_01.show()
		gear_04.show()
		gear_05.show()
		if m_2_set:
			sound3.play(0)
			m_2.hide()
			m_dup_02.hide()
			gear_dup_06.hide()
			gear_dup_07.hide()
			m_gear_02.show()
			gear_06.show()
			gear_07.show()
			if m_3_set:
				sound4.play(0)
				m_3.hide()
				m_dup_03.hide()
				gear_dup_08.hide()
				gear_dup_09.hide()
				gear_dup_10.hide()
				m_gear_03.show()
				gear_08.show()
				gear_09.show()
				gear_10.show()
				emit_signal("repaired")


func _on_medium_gear_mouse_entered():
	gear_entered = 1
func _on_medium_gear_mouse_exited():
	gear_entered = 0

func _on_small_gear_mouse_entered():
	gear_entered = 2
func _on_small_gear_mouse_exited():
	gear_entered = 0

func _on_big_gear_mouse_entered():
	gear_entered = 3
func _on_big_gear_mouse_exited():
	gear_entered = 0


func _on_anchor_1_mouse_entered():
	anchor_entered = 1
func _on_anchor_1_mouse_exited():
	anchor_entered = 0
	
func _on_anchor_2_mouse_entered():
	anchor_entered = 2
func _on_anchor_2_mouse_exited():
	anchor_entered = 0

func _on_anchor_3_mouse_entered():
	anchor_entered = 3
func _on_anchor_3_mouse_exited():
	anchor_entered = 0


func gear_animation(delta):
	gear_01.rotation += 1 * delta
	gear_02.rotation -= 1 * delta
	gear_03.rotation += 1 * delta
	m_gear_01.rotation -= 1 * delta
	gear_04.rotation += 1 * delta
	gear_05.rotation -= 1 * delta
	m_gear_02.rotation += 1 * delta
	gear_06.rotation -= 1 * delta
	gear_07.rotation += 1 * delta
	m_gear_03.rotation -= 1 * delta
	gear_08.rotation += 1 * delta
	gear_09.rotation -= 1 * delta
	gear_10.rotation += 1 * delta


func _on_sound_1_finished():
	sound1.play(0.2)


func _on_sound_2_finished():
	sound2.play(0)


func _on_sound_3_finished():
	sound3.play(0)


func _on_sound_4_finished():
	sound4.play(0)
