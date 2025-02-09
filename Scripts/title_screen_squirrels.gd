extends Node3D
@onready var animation_player1: AnimationPlayer = $squirrel/AnimationPlayer
@onready var animation_player2: AnimationPlayer = $squirrel2/AnimationPlayer
@onready var animation_boat: AnimationPlayer = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animation_player1.play("Squirrel 1 | Menu_screen_1")
	#animation_player2.play("Squirrel 1 | Menu_screen_2")
	animation_boat.play("titlescreen_boat_bob")
	animation_boat.play("camera_pan")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
