class_name Player
extends CharacterBody3D

@export var speed: float
@export var turn_rate: float
@onready var dash: Dash = $Dash
@onready var rescue: Rescue = $Rescue
var rescuing: bool = false
var dashing: bool = false
var burning: bool = false
var current_tile: Tile
signal burning_changed(value: bool)
signal rescuing_changed(value: bool)
signal dashing_changed(value: bool)
@onready var zeppelinare: Node3D = $Zeppelinare

func set_rescuing(value):
	rescuing = value
	rescuing_changed.emit(value)
	
func set_dashing(value):
	dashing = value
	dashing_changed.emit(value)
	
func set_burning(value):
	burning = value
	burning_changed.emit(value)

func _physics_process(delta: float) -> void:
	check_tile()
	
	if Input.is_action_just_pressed("ui_accept"):
		dash.dash()
		
	if Input.is_action_just_pressed("shift") and current_tile.has_ollon:
		set_rescuing(true)
		
	elif rescuing and Input.is_action_pressed("shift"):
		return
		
	elif rescuing and not Input.is_action_pressed("shift"):
		set_rescuing(false)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var forward = Input.is_action_pressed("ui_up")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	if left or right:
		var turn_multiplier = 1 if forward else 2
		rotation.y += turn_rate * turn_multiplier if left else -turn_rate * turn_multiplier
	if forward:
		velocity = global_transform.basis * Vector3(0,0, -speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed/10)
		velocity.z = move_toward(velocity.z, 0, speed/10)
		#velocity.x = move_toward(velocity.x, direction.x * speed, speed/5)
	zeppelinare.rotation.x = 0.26 if left else -0.26 if right else 0
	move_and_slide()
	
func check_tile():
	if current_tile == null:
		return 
		
	if current_tile.state == Tile.TileState.FIRE and not burning:
		set_burning(true)
		
	if current_tile.state != Tile.TileState.FIRE and burning:
		set_burning(false)
		
	if not current_tile.has_ollon and rescuing:
		set_rescuing(false)
