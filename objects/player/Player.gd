extends CharacterBody3D


## Speeds
var current_speed = 5.0
const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0
## Gravity and jump
const jump_velocity = 7
const grav_multiplier = 2
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
# Get the gravity from the project settings to be synced with RigidBody nodes.
## Mouselook
const mouse_sens = 0.3
## Imports
@onready var head = $Head
@onready var animation_player = $Head/Camera3D/Weapons_Manager/FPS_Rig/AnimationPlayer
## Misc
var cur_wp = "empty"


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Make the cursor not leave the screen

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * mouse_sens)) # Look left and right, yeah its rotate_y...
		head.rotate_x(-deg_to_rad(event.relative.y * mouse_sens)) # Look up and down
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89)) 
		# Limit how much we can look up and down

func _physics_process(delta):
	# Sprinting
	if Input.is_action_pressed("mv_sprint"):
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * grav_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	# Draw weapon
	if Input.is_action_just_pressed("mv_wp_1"):
		if cur_wp == "pistol":
			animation_player.play("pistol_hide")
			cur_wp = "empty"
		else:
			animation_player.play("pistol_pull_out")
			cur_wp = "pistol"
	
	if Input.is_action_just_pressed("mv_wp_2"):
		if cur_wp == "pumpsg":
			animation_player.play("pumpsg_hide")
			cur_wp = "empty"
		else:
			animation_player.play("pumpsg_pull_out")
			cur_wp = "pumpsg"
	
	if Input.is_action_just_pressed("mv_wp_3"):
		if cur_wp == "dbavg":
			animation_player.play("dbavg_hide")
			cur_wp = "empty"
		elif cur_wp == "dblong":
			animation_player.play("dblong_hide")
			cur_wp = "empty"
		else:
			animation_player.play("dbavg_pull_out")
			cur_wp = "dbavg"
	
	if Input.is_action_just_pressed("mv_wp_swap"):
		if cur_wp == "dbavg":
			animation_player.play("dblong_pull_out")
			cur_wp = "dblong"
		elif cur_wp == "dblong":
			animation_player.play("dbavg_pull_out")
			cur_wp = "dbavg"
	
	# Shooting
	if Input.is_action_pressed("mv_shoot"):
		if !animation_player.is_playing():
			if cur_wp == "pistol":
				animation_player.play("pistol_shoot")
			if cur_wp == "pumpsg":
				animation_player.play("pumpsg_shoot")
			if cur_wp == "dbavg":
				animation_player.play("dbavg_shoot")
			if cur_wp == "dblong":
				animation_player.play("dblong_shoot")

	move_and_slide()
