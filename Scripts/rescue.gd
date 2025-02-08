class_name Rescue
extends Node

@export var rescue_time: float
var current_rescue_time: float
@onready var player: Player = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func stop_rescuing():
	player.rescuing = false
	current_rescue_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.rescuing:
		current_rescue_time += delta
		if current_rescue_time > rescue_time:
			print("WOW U SAVED THE SQIURREL!!")
			player.current_tile.has_ollon = false
			stop_rescuing()
	else:
		stop_rescuing()
	pass
