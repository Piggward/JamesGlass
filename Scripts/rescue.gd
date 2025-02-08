class_name Rescue
extends Node

@export var rescue_time: float
var current_rescue_time: float
@onready var player: Player = $".."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
var moving_vertically = false
var process: bool = false

signal ollon_rescued

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.rescuing_changed.connect(_on_rescuing_changed)
	pass # Replace with function body.
	
func _on_rescuing_changed(value):
	if value:
		start_rescuing()
	else:
		stop_rescuing()

func stop_rescuing():
	process = false
	animation_player.play_backwards("rescue")
	await animation_player.animation_finished
	moving_vertically = false
	player.rescuing = false
	current_rescue_time = 0
	
func start_rescuing():
	process = true
	moving_vertically = true
	animation_player.play("rescue")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if process:
		if player.rescuing:
			current_rescue_time += delta
			if current_rescue_time > rescue_time:
				print("WOW U SAVED THE SQIURREL!!")
				ollon_rescued.emit()
				player.current_tile.has_ollon = false
				stop_rescuing()
