extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 500
@export var max_fall = 800

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2

var is_crouching = false
var stuck_under_object = false
var standing_cshape = preload("res://Resources/knight_standing_cshape.tres")
var crouching_cshape = preload("res://Resources/knight_crouching_cshape.tres")


func _process(delta):
	pass

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > max_fall:
			velocity.y = max_fall
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	
	if Input.is_action_just_released("jump"):
		velocity.y = 0
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	
	if horizontal_direction != 0:
		switch_direction(horizontal_direction)
		
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if above_head_is_empty():
			stand()
		else:
			if stuck_under_object != true:
				stuck_under_object = true
				print ("stuck")
	if stuck_under_object && above_head_is_empty():
		stand()
		stuck_under_object = false
		print("unstuck")
		
	move_and_slide()
	
	update_animations(horizontal_direction)
	
func above_head_is_empty() -> bool:
		var result = !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding()
		return result
	
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			if is_crouching:
				ap.play("crouch")
			else:
				ap.play("idle")
		else:
			if is_crouching:
				ap.play("crouch_walk")
			else:
				ap.play("run")
	else:
		if is_crouching == false:
			if velocity.y <0:
				ap.play("jump")
			elif velocity.y >= 0:
				ap.play("fall")
		else:
			ap.play("crouch")

func switch_direction(horizontal_direction):
	sprite.flip_h = (horizontal_direction == -1)
	sprite.position.x = horizontal_direction * 4
	
func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape 
	cshape.position.y = -12
	
func stand():
	if is_crouching == false:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = -16
	
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0 

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#func _physics_process(delta):
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

#	move_and_slide()
