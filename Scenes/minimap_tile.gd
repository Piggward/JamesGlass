class_name MinimapTile
extends ColorRect

@export var minx: float
@export var miny: float
@export var tile: Tile

var green = "#2f4d2f" 
var brown = "#7a5859" 
var red = "#b55945" 
var gold = "#de9f47" 
var gray = "#d5d6db"
var purple = "#ADD8E6"
var offset = null

# Called when the node enters the scene tree for the first time.
func _ready():
	update_color(tile)
	tile.tile_change.connect(update_color)
	self.set_custom_minimum_size(Vector2(minx, miny))
	pass # Replace with function body.


func update_color(tile: Tile):
	if tile.has_player:
		var camera = get_tree().get_first_node_in_group("minimap_camera")
		var minimap = get_tree().get_first_node_in_group("minimap")
		if camera.initial_offset == Vector2.ZERO:
			camera.initial_offset = self.global_position
		color = Color(gold)
		camera.global_position = Vector2(self.global_position.x, global_position.y)
		#minimap.chill = true
		#var rot = minimap.rotation
		#minimap.rotation = 0
		#minimap.pivot_offset = minimap.og_pos + self.global_position
		#minimap.global_position = minimap.og_pos
		#minimap.rotation = rot 
		#minimap.chill = false
		return
	if tile.has_ollon:
		color = Color(brown)
		return
		
	match (tile.state):
		Tile.TileState.MOUNTAIN:
			color = Color(gray)
		Tile.TileState.GRASS, Tile.TileState.LANDING:
			color = Color(green)
		Tile.TileState.DRYWOOD, Tile.TileState.FIRE:
			color = Color(red)
		Tile.TileState.BASE:
			color = Color(purple)
