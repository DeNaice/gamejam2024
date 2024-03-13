extends CharacterBody2D

################################_NODES_################################
@onready var skin = $Skin
@onready var animation = $Animations
@onready var audio = $AudioStreamPlayer


################################_EXPORT_VARIABLES_################################
@export var speed = 300.0
@export var jump_velocity = 700.0
@export var gravity = 1500

################################_ENUMS_################################

enum Anim {WALK, JUMP, IDLE, REPAIR}

################################_GLOBAL_VARIABLES_################################

var movement_locked = false
var current_animation = Anim.IDLE

################################_SIGNALS_################################
signal interact

################################_SETUP_################################
func _ready():
	pass

func _physics_process(delta):

	################################_GRAVITY_################################
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		current_animation = Anim.IDLE
	
	if movement_locked:
		velocity.x = 0
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y = 1000
	else:
		################################_INPUT_################################
		var direction = Input.get_axis("move_left", "move_right")	
	
		if direction:
			skin.flip_h = false if direction > 0 else true
			current_animation = Anim.WALK
	
		if Input.is_action_just_pressed("jump") and is_on_floor():
			audio.play(0.1)
			velocity.y = -jump_velocity
			current_animation = Anim.JUMP

		if Input.is_action_just_pressed("interact"):
			emit_signal("interact")
			#current_animation = Anim.REPAIR

	
		################################_MOVE_################################
	
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
		animate(is_on_floor())
	
	move_and_slide()


func animate(on_floor):
	match current_animation:
		Anim.IDLE:
			animation.play("Idle")
		Anim.WALK:
			if on_floor:
				animation.play("Walk")
		Anim.JUMP:
			animation.play("Jump")
		Anim.REPAIR:
			movement_locked = true
			animation.play("Repair")
			await get_parent().repaired
			movement_locked = false



func _on_node_2d_repair_started():
	current_animation = Anim.REPAIR
	animate(is_on_floor())
	pass # Replace with function body.
