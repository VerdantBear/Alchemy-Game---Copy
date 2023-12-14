extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	DEATH
}

var state = State.IDLE
var health = 10
var courage = 0
const SPEED = 95.0
const JUMP_VELOCITY = -170.0
var is_throwing = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimatedSprite2D")

var snapcracker_scene = preload("res://Throwables/Snapcracker.tscn")
var snapcracker_instance
var prev_position = Vector2.ZERO

func _ready():
	snapcracker_instance = snapcracker_scene.instantiate()
	add_child(snapcracker_instance)
	snapcracker_instance.hide()

func _process(_delta):
	if state == State.DEATH: return
	handle_input()
	handle_animation()

func _physics_process(delta):
	if state == State.DEATH: return
	handle_movement(delta)

func handle_input():
	if Input.is_action_just_pressed("left_click") and !is_throwing:
		is_throwing = true
	elif Input.is_action_just_released("left_click") and is_throwing:
		throw_snapcracker()
		is_throwing = false

	if Input.is_action_pressed("jump") and is_on_floor():
		state = State.JUMP
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		state = State.RUN
	
	elif velocity.y == 0 and state in [State.FALL, State.RUN]:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state = State.IDLE
	
	if velocity.y > 0:
		state = State.FALL

	if health <= 0:
		state = State.DEATH
	
	handle_flip()

func handle_flip():
	if is_throwing:
		var throw_direction = get_global_mouse_position() - global_position
		if throw_direction.x < 0:
			$AnimatedSprite2D.flip_h = true  # Flip the sprite to face left
		elif throw_direction.x > 0:
			$AnimatedSprite2D.flip_h = false   # Set the scale to face right
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func handle_animation():
	#If you want the throwing animation to be overwritten when another animation happens, you could move it to line 98 after the match
	if is_throwing:
		anim.play("Throw")
		return
		
	match state:
		State.IDLE:
			if anim.animation != "Idle":
				anim.play("Idle")
				return
		State.RUN:
			if anim.animation != "Run":
				anim.play("Run")
				return
		State.JUMP:
			if anim.animation != "Jump":
				anim.play("Jump")
				return
		State.FALL:
			if anim.animation != "Fall":
				anim.play("Fall")
				return
		State.DEATH:
			if anim.animation != "Death":
				anim.play("Death")
				return


func handle_movement(delta):
	if state != State.DEATH:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func throw_snapcracker():
	#Spawn a cracker and throw it in the direction of mouse here
	pass

