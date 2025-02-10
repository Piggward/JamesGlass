extends Control

var width: float
var height: float
var tile_map = []
const MARGIN = 10
@onready var v_box_container = $VBoxContainer
const MINIMAP_HBOX = preload("res://Scenes/minimap_hbox.tscn")
@onready var game_manager = $"../../../.."
var single_width
var single_height
@onready var camera_2d = $"../Camera2D"
var player: Player
var og_pos: Vector2
var chill: bool

func _ready():
	player = get_tree().get_first_node_in_group("player")
	og_pos = self.global_position
	
func create_mini_map():
	var tile_map = game_manager.tiles_map
	var rows = tile_map.size()
	var columns = tile_map[0].size()
	
	var viewport = get_viewport_rect()
	
	self.size.x = viewport.size.x - self.position.x - MARGIN
	self.size.y = viewport.size.y - self.position.y - MARGIN
	
	single_width = self.size.x / columns
	single_height = self.size.y / rows
	
	var current_row = 0
	for i in game_manager.MAP_SIZE:
		var hbox = MINIMAP_HBOX.instantiate()
		for j in game_manager.MAP_SIZE:
			var tile = tile_map[i][j]
			var mini = MinimapTile.new()
			mini.minx = single_width
			mini.miny = single_height
			mini.tile = tile
			hbox.add_child(mini)
		v_box_container.add_child(hbox)

#func _process(delta):
	#var player_pos = (game_manager.global_position - player.global_position)
	#var real_width = 8
	#var ratio_x = player_pos.x / real_width
	#var ratio_y = player_pos.z / real_width
	#
	#var mini_pos = Vector2(abs(ratio_x * single_height), abs(ratio_y * single_width))
	#camera_2d.global_position = og_pos + mini_pos + camera_2d.initial_offset
	#self.rotation = player.rotation.y
