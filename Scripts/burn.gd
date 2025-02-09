class_name Burn
extends Node

@onready var player: Player = $".."
@export var max_burn_time: float
var current_burn_time: float = 0.0
@onready var panel: Panel = $"../../CanvasLayer/Panel"
@onready var node_3d: Node3D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.burning:
		current_burn_time += delta
		if current_burn_time > max_burn_time:
			# Jag lämnar gamla overlay koden ifall vi vill gå tillbaka att göra nåt sånt ist :D 
			#panel.visible = true
			#node_3d.process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
			
	elif current_burn_time > 0:
		current_burn_time -= delta
	pass
