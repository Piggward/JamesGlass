class_name Rescue
extends Node

@export var rescue_time: float
var current_rescue_time: float
@onready var player: Player = $".."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
var moving_vertically = false
var process: bool = false
@onready var collect_effect: Node3D = $"../Zeppelinare/CollectEffect"

signal ollon_rescued

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.rescuing_changed.connect(_on_rescuing_changed)
	pass # Replace with function body.
	
func _on_rescuing_changed(value):
	#if value:
	start_rescuing()


func stop_rescuing():
	process = false
	animation_player.play_backwards("rescue")
	animation_player.speed_scale = 2
	await animation_player.animation_finished
	animation_player.speed_scale = 1
	moving_vertically = false
	player.rescuing = false
	current_rescue_time = 0
	
func start_rescuing():
	process = true
	moving_vertically = true
	animation_player.play("rescue")
	current_rescue_time = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if process:
			if(player.current_tile.has_ollon):
				print("WOW U SAVED THE SQIURREL!!")
				EventManager.ollon_aquired.emit(player.current_tile.pos)
				collect_effect.emit_collect_effect()
				player.current_tile.has_ollon = false
			
			current_rescue_time += delta
			if current_rescue_time > rescue_time:
				stop_rescuing()
				#if(player.current_tile.has_ollon):
				#	print("WOW U SAVED THE SQIURREL!!")
				#	EventManager.ollon_aquired.emit(player.current_tile.pos)
				#	player.current_tile.has_ollon = false
					

					
