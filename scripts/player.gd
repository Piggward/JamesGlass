class_name Player
extends CharacterBody3D

@export var speed: float
var original_speed: float
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
@onready var propeller_ljud: AudioStreamPlayer3D = $Zeppelinare/Zeppelinare/Propeller/PropellerLjud
@onready var zeppelinare: Node3D = $Zeppelinare
@onready var swing_wind: AudioStreamPlayer3D = $Zeppelinare/Zeppelinare/SwingWind

func _ready() -> void:
	dash.propeller_ljud = propeller_ljud
	original_speed = speed

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
	
	if Input.is_action_just_pressed("dash") and Input.is_action_pressed("up"):
		dash.dash()
		
	if dashing && Input.is_action_just_released("dash"):
		dash.end_dash()
	

	if Input.is_action_just_pressed("action"):
		set_rescuing(true)	

		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var forward = Input.is_action_pressed("up")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var turn_speed_factor = 1
	if(dashing):
		turn_speed_factor = original_speed/(speed*1.5)
	else:
		turn_speed_factor = 1
	if left or right:
		var turn_multiplier = 1 if forward else 1
		rotation.y += turn_rate * turn_multiplier * turn_speed_factor if left else -turn_rate * turn_multiplier * turn_speed_factor
		if not swing_wind.is_playing():
			swing_wind.pitch_scale = randf_range(0.9, 1.1)
			swing_wind.play(0)
	elif not left and not right:
		swing_wind.stop()
	if forward:
		velocity = global_transform.basis * Vector3(0,0, -speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed/10)
		velocity.z = move_toward(velocity.z, 0, speed/10)
		#velocity.x = move_toward(velocity.x, direction.x * speed, speed/5)
		
	var tilt_factor = 0.6 if left else -0.6 if right else 0
	zeppelinare.rotation.x = move_toward(zeppelinare.rotation.x, tilt_factor, 0.1)
	
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
