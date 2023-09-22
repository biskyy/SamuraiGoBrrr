extends RigidBody3D

@export_group("Movement")
@export var speed: float = 1200

@export_group("Camera")
@export var mouse_sensitivity := 0.001
var xRotationInput := 0.0
var yRotationInput := 0.0

@onready var xRotation := $xRotation
@onready var yRotation := $xRotation/yRotation
@onready var globalWorld = get_node("/root/GlobalWorld")

var input := Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	globalWorld.speedLabel.text = str(int(linear_velocity.length()))
	RotateCamera()
	MyInput()

func _physics_process(delta):
	apply_central_force(xRotation.basis * input * speed * delta)

func MyInput():
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			xRotationInput = - event.relative.x * mouse_sensitivity
			yRotationInput = - event.relative.y * mouse_sensitivity

func RotateCamera():
	xRotation.rotate_y(xRotationInput)
	yRotation.rotate_x(yRotationInput)
	yRotation.rotation.x = clamp(yRotation.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	xRotationInput = 0
	yRotationInput = 0

