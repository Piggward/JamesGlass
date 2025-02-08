class_name Player
extends CharacterBody3D

@export var speed: float
@onready var dash: Dash = $Dash
@onready var rescue: Rescue = $Rescue
var rescuing: bool = false
var dashing: bool = false
var burning: bool = false
var current_tile: Tile

func _physics_process(delta: float) -> void:
	check_tile()
	
	if Input.is_action_just_pressed("ui_accept"):
		dash.dash()
		
	if Input.is_action_just_pressed("shift") and current_tile.has_ollon:
		rescuing = true
		
	elif rescuing and Input.is_action_pressed("shift"):
		return
		
	elif rescuing and not Input.is_action_pressed("shift"):
		rescuing = false
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.z = move_toward(velocity.z, direction.z * speed, speed/5)
		velocity.x = move_toward(velocity.x, direction.x * speed, speed/5)
	else:
		velocity.x = move_toward(velocity.x, 0, speed/10)
		velocity.z = move_toward(velocity.z, 0, speed/10)

	move_and_slide()
	
func check_tile():
	if current_tile == null:
		return 
		
	if current_tile.state == Tile.TileState.FIRE and not burning:
		burning = true
		
	if current_tile.state != Tile.TileState.FIRE and burning:
		burning = false
		
	if not current_tile.has_ollon and rescuing:
		rescuing = false
