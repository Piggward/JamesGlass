class_name Player
extends CharacterBody3D

@export var speed: float
@onready var dash: Dash = $Dash
var dashing: bool = false

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		dash.dash()
		
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
		
	print(speed)
	move_and_slide()
