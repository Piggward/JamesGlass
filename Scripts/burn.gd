class_name Burn
extends Node

@onready var player: Player = $".."
@export var max_burn_time: float
var current_burn_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.burning:
		current_burn_time += delta
		if current_burn_time > max_burn_time:
			print("GAME OVER PLAYER BURNED OUT")
	elif current_burn_time > 0:
		current_burn_time -= delta
	pass
