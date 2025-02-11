class_name MinimapCamera
extends Camera2D

@onready var game_manager = $"../../../.."

var initial_offset: Vector2
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.


func _process(delta):
	self.rotation = -player.rotation.y
	#print(position)
	pass
