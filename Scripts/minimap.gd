extends Control

@onready var game_manager = $"../.."
var width: float
var height: float
var tile_map = []
const MARGIN = 10
@onready var v_box_container = $VBoxContainer
const MINIMAP_HBOX = preload("res://Scenes/minimap_hbox.tscn")

func create_mini_map():
	var tile_map = game_manager.tiles_map
	var rows = tile_map.size()
	var columns = tile_map[0].size()
	
	var viewport = get_viewport_rect()
	
	self.size.x = viewport.size.x - self.position.x - MARGIN
	self.size.y = viewport.size.y - self.position.y - MARGIN
	
	var single_width = self.size.x / columns
	var single_height = self.size.y / rows
	
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
