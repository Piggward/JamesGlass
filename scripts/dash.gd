class_name Dash
extends Node

var dash_ready: bool = true
@onready var player: Player = $".."
@export var dash_bonus_speed: float
@export var dash_duration: float
@export var dash_accelleration_time_until_max_speed: float
@export var dash_cd: float
var elapsed_dash_time: float
var player_speed_before_dash: float
var base_propeller_pitch = 1.0
var propeller_max_pitch = 2.0
var dash_ending: bool

@export var propeller_ljud: AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func dash():
	if dash_ready:
		dash_ready = false
		player_speed_before_dash = player.speed
		propeller_ljud.pitch_scale = base_propeller_pitch
		elapsed_dash_time = 0
		player.dashing = true
 
func end_dash():
	if player.dashing:
		player.dashing = false
		dash_ending = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player.dashing):
		#if elapsed_dash_time > dash_duration:
			#end_dash()
		#else:
		elapsed_dash_time += delta
		var progress = elapsed_dash_time / dash_accelleration_time_until_max_speed
		var bonus_speed = dash_bonus_speed * ease(progress, 0.1)
		var bonus_pitch = propeller_max_pitch * ease(progress, 0.1)
		player.speed = player_speed_before_dash + bonus_speed
		propeller_ljud.pitch_scale = base_propeller_pitch + bonus_pitch
	elif dash_ending and player.speed > player_speed_before_dash:
		player.speed = move_toward(player.speed, player_speed_before_dash, 0.45)
		propeller_ljud.pitch_scale = move_toward(propeller_ljud.pitch_scale, base_propeller_pitch, 0.15)
		print("slowing down", player.speed)
		if player.speed == player_speed_before_dash:
			dash_ending = false
			dash_ready = true
