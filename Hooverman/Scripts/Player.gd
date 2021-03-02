extends KinematicBody

var walking_speed = 275
var running_speed = 475
var velocity = Vector3.ZERO
var gravity = -9.8
var direction = Vector3.ZERO
var jump_strength = 15

var cameraRotationSpeed = 150
var speed

var cameraFollowSpeed = 5

onready var camera = $CameraRig/Camera
onready var cameraRig = $CameraRig
onready var cursor = $Cursor
onready var game = $"../"
#onready var playerHolder = $Player/PlayerHolder
var joy_axis: Vector3
var camera_basis

var isMouse: bool
var cursorPos: Vector3

func _ready():
	cameraRig.set_as_toplevel(true)
	cursor.set_as_toplevel(true)

func _physics_process(delta):
	camera_basis = camera.get_global_transform().basis
	move_camera(delta)
	rotate_Camera(delta)
	
	look_at_cursor()
	if game.inGame:
		playerMovement()
		velocity.y += gravity * delta
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
		velocity = move_and_slide(velocity, Vector3.UP)

func rotate_Camera(delta):
	if Input.is_action_pressed("rotate_camera_cw"):
		cameraRig.rotate_y(deg2rad(-cameraRotationSpeed * delta))
	elif Input.is_action_pressed("rotate_camera_ccw"):
		cameraRig.rotate_y(deg2rad(cameraRotationSpeed * delta))

func move_camera(delta):
	#cameraRig.global_transform = get_global_transform().interpolate_with(global_transform.basis, delta * cameraFollowSpeed)
	cameraRig.global_transform.origin = global_transform.origin

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		isMouse = true

func look_at_cursor():
	var player_Pos = global_transform.origin
	var drop_Plane = Plane(Vector3(0, 1, 0), player_Pos.y)
	var ray_length = 1000
	var mouse_Pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_Pos)
	var to = from + camera.project_ray_normal(mouse_Pos) * ray_length
	cursorPos = drop_Plane.intersects_ray(from, to)
	
	if Input.is_action_pressed("joystick_aim_left"):
		joy_axis -= camera_basis.x * Input.get_action_strength("joystick_aim_left")
	if Input.is_action_pressed("joystick_aim_right"):
		joy_axis += camera_basis.x * Input.get_action_strength("joystick_aim_right")
	if Input.is_action_pressed("joystick_aim_up"):
		joy_axis -= camera_basis.z * Input.get_action_strength("joystick_aim_up")
	if Input.is_action_pressed("joystick_aim_down"):
		joy_axis += camera_basis.z * Input.get_action_strength("joystick_aim_down")
	
	joy_axis.y = 0
	
	#joy_axis.x = Input.get_action_strength("joystick_aim_left") - Input.get_action_strength("joystick_aim_right")
	#joy_axis.y = Input.get_action_strength("joystick_aim_up") - Input.get_action_strength("joystick_aim_down")
	joy_axis = joy_axis.normalized()
	
	if joy_axis.x != 0 or joy_axis.y != 0:
		isMouse = false
	
	if !isMouse:
		cursorPos = global_transform.origin + joy_axis / 2
		#cursorPos.z = global_transform.origin.z + joy_axis.y / 2
	
	cursor.global_transform.origin = cursorPos# + Vector3(0, 1, 0)
	#playerHolder.look_at(cursorPos, Vector3.le)
	if cursorPos.x != global_transform.origin.x and cursorPos.z != global_transform.origin.z:
		look_at(cursorPos, Vector3.UP)

func playerMovement():
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction -= camera_basis.x * Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_right"):
		direction += camera_basis.x * Input.get_action_strength("move_right")
	if Input.is_action_pressed("move_forward"):
		direction -= camera_basis.z * Input.get_action_strength("move_forward")
	if Input.is_action_pressed("move_backward"):
		direction += camera_basis.z * Input.get_action_strength("move_backward")
	
	direction.y = 0
	
	if Input.is_action_pressed("move_running"):
		speed = running_speed
	else:
		speed = walking_speed
	
	direction = direction.normalized()
	pass
